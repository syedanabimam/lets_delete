require 'rails_helper'

RSpec.describe Item do
  describe '#validations' do
    let(:list) { create(:list) }

    context 'and list is present' do
      let(:item) { described_class.new(list: list) }

      it 'is invalid if name is not present' do
        expect(item).to be_invalid
        expect(item.errors.full_messages).to contain_exactly(
          "Name can't be blank"
        )
      end
    end

    context 'and list is not present' do
      let(:item) { described_class.new }

      it 'is invalid if name is not present' do
        expect(item).to be_invalid
        expect(item.errors.full_messages).to contain_exactly(
          'List must exist', "Name can't be blank"
        )
      end
    end
  end

  describe 'scopes' do
    let(:items) { create_list(:item, 2) }

    before { items.first.soft_delete }

    describe '.active' do
      subject { described_class.active }

      it { is_expected.to contain_exactly(items.last) }
    end

    describe '.soft_deleted' do
      subject { described_class.soft_deleted }

      it { is_expected.to contain_exactly(items.first) }
    end
  end

  describe '#soft_delete' do
    let(:item) { create(:item) }

    it 'will soft delete the item by marking deleted at field' do
      expect { item.soft_delete }.to change(item, :deleted_at)
      expect(item.deleted_at).not_to be_nil
    end
  end

  describe '#recover' do
    let(:item) { create(:item, :soft_deleted) }

    it 'will recover the item by updating deleted at field' do
      expect { item.recover }.to change(item, :deleted_at)
      expect(item.deleted_at).to be_nil
    end
  end
end
