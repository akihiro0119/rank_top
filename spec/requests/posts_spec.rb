require 'rails_helper'
describe PostsController, type: :request do

  before do
    @post = FactoryBot.create(:post)
  end

    describe "GET #index" do

      it "indexアクションにリクエストすると正常にレスポンスが返ってくる" do 
        get root_path
        expect(response.status).to eq 200
      end

      it "indexアクションにリクエストするとレスポンスに投稿済みのタイトルが存在する" do
        get root_path
        expect(response.body).to include @post.title
      end
      it "indexアクションにリクエストするとレスポンスに投稿済みのタイトルが存在する" do 
        get post_path(@post)
        expect(response.body).to include @post.rank1
      end
      it "indexアクションにリクエストするとレスポンスに投稿済みのRank1が存在する" do 
        get post_path(@post)
        expect(response.body).to include @post.rank2
      end
      it "indexアクションにリクエストするとレスポンスに投稿済みのRank2が存在する" do 
        get post_path(@post)
        expect(response.body).to include @post.rank3
      end

      it "indexアクションにリクエストするとレスポンスに検索フォームが存在する" do
        get root_path
        expect(response.body).to include "投稿を検索する" 
      end
      
    end

    describe "GET #show" do
      it "showアクションにリクエストすると正常にレスポンスが返ってくる" do 
        get post_path(@post)
        expect(response.status).to eq 200
      end

      it "showアクションにリクエストするとレスポンスに投稿済みのtitleが存在する" do 
        get post_path(@post)
        expect(response.body).to include @post.title
      end
      it "showアクションにリクエストするとレスポンスに投稿済みのrank1が存在する" do 
        get post_path(@post)
        expect(response.body).to include @post.rank1
      end
      it "showアクションにリクエストするとレスポンスに投稿済みのRank2が存在する" do 
        get post_path(@post)
        expect(response.body).to include @post.rank2
      end
      it "showアクションにリクエストするとレスポンスに投稿済みのRank3が存在する" do 
        get post_path(@post)
        expect(response.body).to include @post.rank3
      end

      it "showアクションにリクエストするとレスポンスにコメント一覧表示部分が存在する" do 
        get post_path(@post)
        expect(response.body).to include "＜コメント一覧＞"
      end
    end
end
