describe 'Something flawed' do

  it 'passes' do
    expect(true).to be
  end

  it 'fails' do
    expect(false).to be
  end

  it 'is pending' do
    pending
    expect(false).to be
  end

end
