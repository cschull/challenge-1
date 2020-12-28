require 'csv'
require 'byebug'

class ReportsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_server

  def handle
    report = params["reports.csv"].open
    p report
    csv_options = { col_sep: ",", headers: true }
    CSV.parse( report, csv_options ) do |timestamp, lock_id, kind, status|
      timestamp = timestamp
      lock_id = lock_id
      kind = kind
      status_change = status
      lock = Lock.find_by_id(lock_id)
      if lock
        lock.status = status_change
      else
        lock = Lock.create(id: lock_id, kind: kind, status: status_change)
      end
      Entry.create(timestamp: timestamp, status_change: status_change, lock: lock)
    end

    render json: { message: 'Your report has been processed. You now have #{Lock.count} lock and #{Entry.count} entries.' }
  end

  def authenticate_server
    code_name = params['X-Server-CodeName']
    token = params['X-Server-Token']
    server = Server.where(["code_name = ?", code_name]).first
    unless server && server.access_token == token
      render json: { message: 'wrong credentials' }
    end
  end

end
