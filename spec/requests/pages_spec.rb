require 'rails_helper'

RSpec.describe 'Pages' do
  describe 'GET: /trash' do
    let!(:lists) { create_list(:list, 2) }
    let!(:soft_deleted_list) { create(:list, :soft_deleted) }

    context 'when lists have no items' do
      it 'returns the lists which are soft deleted' do
        get '/trash'

        expect(response).to be_successful
        expect(response.body).not_to include(lists.first.name)
        expect(response.body).not_to include(lists.last.name)
        expect(response.body).to include(soft_deleted_list.name)
      end
    end

    context 'when list has items' do
      let!(:item) { create(:item, list: lists.first) }
      let!(:soft_deleted_items) { create_list(:item, 2, :soft_deleted, list: soft_deleted_list) }

      it 'returns the lists along with items which are soft deleted' do
        get '/trash'

        expect(response).to be_successful
        expect(response.body).not_to include(lists.first.name)
        expect(response.body).not_to include(lists.last.name)
        expect(response.body).not_to include(item.name)
        expect(response.body).to include(soft_deleted_list.name)
        expect(response.body).to include(soft_deleted_items.first.name)
        expect(response.body).to include(soft_deleted_items.last.name)
      end
    end
  end
end
