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
        expect(@post.errors.full_messages).to include("タイトルを入力してください")
      end
      it 'Rank1がないと投稿は保存できない' do
        @post.rank1 = nil
        @post.valid?
        expect(@post.errors.full_messages).to include("1位を入力してください")
      end
      it 'Rank2がないと投稿は保存できない' do
        @post.rank2 = nil
        @post.valid?
        expect(@post.errors.full_messages).to include("2位を入力してください")
      end
      it 'Rank3がないと投稿は保存できない' do
        @post.rank3 = nil
        @post.valid?
        expect(@post.errors.full_messages).to include("3位を入力してください")
      end
      it 'ユーザーが紐づいていないいと投稿は保存できない' do
        @post.user = nil
        @post.valid?
        expect(@post.errors.full_messages).to include('Userを入力してください')
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
        expect(@post.errors.full_messages).to include('タイトルは40文字以内で入力してください')
      end
      it 'Rank1が41文字以上の投稿は保存できない' do
        @post.rank1 = 'あ' * 41
        @post.valid?
        expect(@post.errors.full_messages).to include('1位は40文字以内で入力してください')
      end
      it 'Rank2が41文字以上の投稿は保存できない' do
        @post.rank2 = 'あ' * 41
        @post.valid?
        expect(@post.errors.full_messages).to include('2位は40文字以内で入力してください')
      end
      it 'Rank3が41文字以上の投稿は保存できない' do
        @post.rank3 = 'あ' * 41
        @post.valid?
        expect(@post.errors.full_messages).to include('3位は40文字以内で入力してください')
      end
    end
  end
end
