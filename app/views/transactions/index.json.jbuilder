json.array!(@transactions) do |transaction|
  json.extract! transaction, :id, :user_id, :transaction_type, :amount
  json.url transaction_url(transaction, format: :json)
end
