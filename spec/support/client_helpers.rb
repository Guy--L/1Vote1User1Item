module ClientHelpers
    def api_item(item_json)
        ar = OpenStruct.new(item_json)
        ar.id = ar.item_id
        ar.time = DateTime.parse(ar.item_created_at).to_time.to_i
        ar.type = ar.item_type
        ar.to_h.to_json
    end
end
