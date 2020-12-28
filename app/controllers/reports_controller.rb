

class ReportsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_server

  def handle
    render json: { message: 'testing' }
    report = params["reports.csv"].open
    csv_options = { col_sep: ",", headers: first_row }
    CSV.parse( reportm csv_options ) do |timestamp, lock_id, kind, status|
      p timestamp[1]
      p lock_id[1]
      p kind[1]
      p status[1]
    end
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
