Sequel.migration do
  change do
    create_table :logs do
      primary_key :id
      String :app, null: false
      String :message, null: false, text: true
      TrueClass :is_error, null: false, default: false
      DateTime :created_at, null: false, default: Sequel.lit('unixepoch()')
    end
  end
end
