require 'rails_helper'

RSpec.describe List do
  describe '#validations' do
    let(:list) { described_class.new }

    it 'is invalid if name is not present' do
      expect(list).to be_invalid
      expect(list.errors.full_messages).to contain_exactly(
        "Name can't be blank"
      )
    end
  end

  describe 'scopes' do
    let(:lists) { create_list(:list, 2) }

    before { lists.first.soft_delete }

    describe '.default_scoped' do
      subject { described_class.default_scoped }

      it { is_expected.to contain_exactly(lists.last) }
    end

    describe '.soft_deleted' do
      subject { described_class.soft_deleted }

      it { is_expected.to contain_exactly(lists.first) }
    end
  end

  describe '#soft_delete' do
    let(:list)   { create(:list) }
    let!(:items) { create_list(:item, 2, list: list) }

    it 'will soft delete the list and associated items by marking deleted at field' do
      expect { list.soft_delete }.to change(list, :deleted_at)
      items.map(&:reload)
      expect(items.map(&:deleted_at)).not_to include(nil)
      expect(list.deleted_at).not_to be_nil
    end
  end

  describe '#recover' do
    let(:list) { create(:list, :soft_deleted) }

    it 'will recover the list by updating deleted at field' do
      expect { list.recover }.to change(list, :deleted_at)
      expect(list.deleted_at).to be_nil
    end
  end
end
