RSpec.shared_examples 'a policy' do |method|
  subject do
    if instance.present?
      described_class.new(user).public_send(method, instance.uuid)
    else
      described_class.new(user).public_send(method)
    end
  end

  it { is_expected.to eq(expected_result) }
end
