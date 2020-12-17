require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'post新規投稿' do
    before do
      @post = FactoryBot.build(:post)
    end

    context '投稿がうまくいく時' do
      it '全ての入力が正しく行われている' do
        expect(@post).to be_valid
      end
    end

    context '投稿が保存できない場合' do
      it 'タイトルがないと投稿は保存できない' do
        @post.title = nil
        @post.valid?
        expect(@post.errors.full_messages).to include("Title can't be blank")
      end
      it 'Rank1がないと投稿は保存できない' do
        @post.rank1 = nil
        @post.valid?
        expect(@post.errors.full_messages).to include("Rank1 can't be blank")
      end
      it 'Rank2がないと投稿は保存できない' do
        @post.rank2 = nil
        @post.valid?
        expect(@post.errors.full_messages).to include("Rank2 can't be blank")
      end
      it 'Rank3がないと投稿は保存できない' do
        @post.rank3 = nil
        @post.valid?
        expect(@post.errors.full_messages).to include("Rank3 can't be blank")
      end
      it 'ユーザーが紐づいていないいと投稿は保存できない' do
        @post.user = nil
        @post.valid?
        expect(@post.errors.full_messages).to include('User must exist')
      end
      it '新規投稿日時がないと投稿は保存できない' do
        @post.created_at = nil
        @post.valid?
      end
      it '最終保存日時がないと投稿は保存できない' do
        @post.updated_at = nil
        @post.valid?
      end
      it 'タイトルが41文字以上の投稿は保存できない' do
        @post.title = 'あ' * 41
        @post.valid?
        expect(@post.errors.full_messages).to include('Title is too long (maximum is 40 characters)')
      end
      it 'Rank1が41文字以上の投稿は保存できない' do
        @post.rank1 = 'あ' * 41
        @post.valid?
        expect(@post.errors.full_messages).to include('Rank1 is too long (maximum is 40 characters)')
      end
      it 'Rank2が41文字以上の投稿は保存できない' do
        @post.rank2 = 'あ' * 41
        @post.valid?
        expect(@post.errors.full_messages).to include('Rank2 is too long (maximum is 40 characters)')
      end
      it 'Rank3が41文字以上の投稿は保存できない' do
        @post.rank3 = 'あ' * 41
        @post.valid?
        expect(@post.errors.full_messages).to include('Rank3 is too long (maximum is 40 characters)')
      end
    end
  end
end
