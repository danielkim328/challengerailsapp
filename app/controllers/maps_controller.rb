class MapsController < ApplicationController
  def show
    # Create Summation Clause for transaction type: earnings_only, charges_only (default: all)
    sum_clause = ""
    case params[:transaction_type]
      when "earnings_only"
        sum_clause += "SUM(CASE WHEN transactions.transaction_type = 'earning' THEN transactions.amount ELSE 0 END) AS amounts"
      when "charges_only"
        sum_clause += "SUM(CASE WHEN transactions.transaction_type = 'charge' THEN transactions.amount ELSE 0 END) AS amounts"
      else
        sum_clause += "SUM(CASE WHEN transactions.transaction_type = 'earning' THEN transactions.amount ELSE 0 END) + SUM(CASE WHEN transactions.transaction_type = 'charge' THEN transactions.amount ELSE 0 END) * -1 AS amounts"
    end

    # Select user ids sorted by transaction amount 
    user_sql =  "SELECT users.id, #{sum_clause} FROM users, transactions
                WHERE users.id = transactions.user_id
                GROUP BY users.id
                ORDER BY amounts DESC"

    limit_clause = ""

    # limit the number of users
    if params[:limit]
      limit_clause += " LIMIT #{params[:limit]} "
    end
    user_sql += limit_clause

    # Get user ids from database
    @user_data = ActiveRecord::Base.connection.execute(user_sql)
    user_ids = []
    @user_data.each do |row| 
      user_ids.push(row["id"])
    end

    # Get Location data for selected users
    @data = Location.joins('LEFT OUTER JOIN users ON users.id = locations.user_id').select("locations.id, locations.user_id, locations,longitude, locations.latitude, users.name, locations.created_at").where("locations.user_id IN (?)", user_ids)

    respond_to do |format|
      format.html
      format.json {render json: @data}
    end
  end
end
