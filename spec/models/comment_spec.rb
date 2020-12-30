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
        expect(@comment.errors.full_messages).to include("Textを入力してください")
      end

      it 'テキストが100文字以上の場合' do
        @comment.text = 'あ' * 10000
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Textは100文字以内で入力してください")
      end
    end
  end
end
