require 'rails_helper'

RSpec.describe 'Items' do
  let!(:list) { create(:list) }

  describe 'GET: /lists/:id/items/:id' do
    let(:item)  { create(:item, list: list) }

    it 'returns an item' do
      get "/lists/#{list.id}/items/#{item.id}"

      expect(response).to be_successful
      expect(response.body).to include(item.name)
    end
  end

  describe 'POST: /lists/:id/items' do
    let!(:item_params) do
      {
        item: { name: 'Rock n Roll' }
      }
    end

    it 'creates the item' do
      post "/lists/#{list.id}/items",
        params: item_params

      expect(Item.last.name).to eq('Rock n Roll')
    end
  end

  describe 'PUT: /lists/:id/items/:id' do
    let!(:item) { create(:item, list: list, name: 'Gandalf') }

    it 'can update the given item' do
      put "/lists/#{list.id}/items/#{item.id}",
        params: { item: { name: 'Soromon' } }

      expect(item.reload.name).to eq('Soromon')
    end
  end

  describe 'POST: /lists/:id/items/:id/soft_delete' do
    let!(:item) { create(:item, list: list, deleted_at: nil) }

    it 'can soft delete the given item' do
      post "/lists/#{list.id}/items/#{item.id}/soft_delete"

      expect(item.reload.deleted_at).not_to be_nil
    end
  end

  describe 'POST: /lists/:id/restore' do
    let!(:item) { create(:item, :soft_deleted, list: list) }

    it 'can restore the given soft deleted item' do
      post "/lists/#{list.id}/items/#{item.id}/restore"

      expect(item.reload.deleted_at).to be_nil
    end
  end

  describe 'DELETE: /lists/:id/items/:id' do
    let!(:item) { create(:item, list: list) }

    it 'deletes the item but not the parent list' do
      expect do
        delete "/lists/#{list.id}/items/#{item.id}"
      end.to(
        change(Item, :count).by(-1)
        .and(change(List, :count).by(0))
      )
    end
  end
end
