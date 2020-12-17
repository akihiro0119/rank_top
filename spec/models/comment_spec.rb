require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = FactoryBot.build(:comment)
  end

  describe 'コメントテスト' do
    context 'コメントがうまくいく場合' do
      it '正しく入力されている場合' do
        expect(@comment).to be_valid
      end
    end
  
    context 'コメントがうまくいかない時' do

      it 'テキストが入力されていない場合' do
        @comment.text = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Text can't be blank", 'Text is invalid. Input full-width characters.')
      end

      it 'テキストが1000文字以上の場合' do
        @comment.text = 'あ' * 100
        @comment.valid?
        expect(@comment.errors.full_messages).to include('Text is too long (maximum is 100 characters)')
      end
    end
  end
end
