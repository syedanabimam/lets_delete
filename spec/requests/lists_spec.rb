require 'rails_helper'

RSpec.describe 'Lists' do
  describe 'GET: /lists' do
    let!(:lists) { create_list(:list, 2) }
    let!(:soft_deleted_list) { create(:list, :soft_deleted) }

    context 'when lists have no items' do
      it 'returns the lists which are not soft deleted' do
        get '/lists'

        expect(response).to be_successful
        expect(response.body).to include(lists.first.name)
        expect(response.body).to include(lists.last.name)
        expect(response.body).not_to include(soft_deleted_list.name)
      end
    end

    context 'when list has items' do
      let!(:item) { create(:item, list: lists.first) }
      let!(:soft_deleted_item) { create(:item, :soft_deleted, list: lists.first) }

      it 'returns the lists along with items which are not soft deleted' do
        get '/lists'

        expect(response).to be_successful
        expect(response.body).to include(lists.first.name)
        expect(response.body).to include(lists.last.name)
        expect(response.body).to include(item.name)
        expect(response.body).not_to include(soft_deleted_list.name)
        expect(response.body).not_to include(soft_deleted_item.name)
      end
    end
  end

  describe 'GET: /lists/:id' do
    let!(:list) { create(:list) }

    it 'returns a list' do
      get "/lists/#{list.id}"

      expect(response).to be_successful
      expect(response.body).to include(list.name)
    end
  end

  describe 'POST: /lists' do
    let!(:list_params) do
      {
        list: { name: 'CD list' }
      }
    end

    it 'creates the list' do
      post '/lists',
        params: list_params

      expect(List.last.name).to eq('CD list')
    end
  end

  describe 'PUT: /lists/:id' do
    let!(:list) { create(:list, name: 'Ellesmere') }

    it 'can update the given list' do
      put "/lists/#{list.id}",
        params: { list: { name: 'Wakanda' } }

      expect(list.reload.name).to eq('Wakanda')
    end
  end

  describe 'POST: /lists/:id/soft_delete' do
    let!(:list) { create(:list, deleted_at: nil) }

    it 'can soft delete the given list' do
      post "/lists/#{list.id}/soft_delete"

      expect(list.reload.deleted_at).not_to be_nil
    end
  end

  describe 'POST: /lists/:id/restore' do
    let!(:list) { create(:list, :soft_deleted) }

    it 'can restore the given soft deleted list' do
      post "/lists/#{list.id}/restore"

      expect(list.reload.deleted_at).to be_nil
    end
  end

  describe 'DELETE: /lists/:id' do
    let!(:list) { create(:list) }

    context 'when list has no items' do
      it 'deletes the list' do
        expect do
          delete "/lists/#{list.id}"
        end.to change(List, :count).by(-1)
      end
    end

    context 'when list has items' do
      before { create_list(:item, 2, list: list) }

      it 'deletes the list and associated items' do
        expect do
          delete "/lists/#{list.id}"
        end.to(
          change(List, :count).by(-1)
          .and(change(Item, :count).by(-2))
        )
      end
    end
  end
end
