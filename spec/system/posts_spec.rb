require 'rails_helper'

RSpec.describe '投稿', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @post_title = Faker::Lorem.sentence
    @post_rank1 = Faker::Lorem.sentence
    @post_rank2 = Faker::Lorem.sentence
    @post_rank3 = Faker::Lorem.sentence
  end
  context '投稿ができるとき'do
    it 'ログインしたユーザーは新規投稿できる' do
     # ログインする
      visit new_user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      find('input[name=commit').click
      expect(current_path).to eq root_path
      # 新規投稿ページへのリンクがあることを確認する
      expect(page).to have_content('投稿する')
      # 投稿ページに移動する
      visit new_post_path
      # フォームに情報を入力する
      fill_in 'post_title', with: @post_title
      fill_in 'post_rank1', with: @post_rank1
      fill_in 'post_rank2', with: @post_rank2
      fill_in 'post_rank3', with: @post_rank3
      # 送信するとPostモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Post.count }.by(1)
      # トップページに遷移する
      visit root_path
      # トップページには先ほど投稿した内容が存在することを確認する
      expect(page).to have_content(@post_title)
    end
  end
  context '投稿ができないとき'do
    it 'ログインしていないと新規投稿ページに遷移できない' do
     # トップページに遷移する
      visit root_path
      # 新規投稿ページへのリンクがない
      expect(page).to have_no_content('投稿する')
    end
  end
end
 
RSpec.describe '投稿編集', type: :system do
  before do
    @post1 = FactoryBot.create(:post)
    @post2 = FactoryBot.create(:post)
  end
  context '投稿編集ができるとき' do
    it 'ログインしたユーザーは自分が投稿した投稿の編集ができる' do
      # 投稿1を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'Email', with: @post1.user.email
      fill_in 'Password', with: @post1.user.password
      find('input[name=commit').click
      expect(current_path).to eq root_path
      # 投稿１の詳細画面へ
      visit post_path(@post1)
      # 編集するボタンをクリック
      click_button '編集する'
      # すでに投稿済みの内容がフォームに入っていることを確認する
      expect(
        find('#post_title').value
      ).to eq @post1.title
      expect(
        find('#post_rank1').value
      ).to eq @post1.rank1
      expect(
        find('#post_rank2').value
      ).to eq @post1.rank2
      expect(
        find('#post_rank3').value
      ).to eq @post1.rank3
      # 投稿内容を編集する
      fill_in 'post_title', with: "#{@post1.title}"
      fill_in 'post_rank1', with: "#{@post1.rank1}"
      fill_in 'post_rank2', with: "#{@post1.rank2}"
      fill_in 'post_rank3', with: "#{@post1.rank3}"
      # 編集してもPostモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Post.count }.by(0)
      # トップページに遷移する
      visit root_path
      # トップページには先ほど変更した内容の投稿が存在することを確認する
      expect(page).to have_content("#{@post1.title}")
      # トップページには先ほど変更した内容の投稿が存在することを確認する（テキスト）
      expect(page).to have_content("#{@post1.rank1}")
      expect(page).to have_content("#{@post1.rank2}")
      expect(page).to have_content("#{@post1.rank3}")
    end
  end
  context '投稿編集ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿した投稿の編集画面には遷移できない' do
      # 投稿1を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'Email', with: @post1.user.email
      fill_in 'Password', with: @post1.user.password
      find('input[name=commit').click
      expect(current_path).to eq root_path
      # 投稿2に「詳細」ボタンがないことを確認する
      expect(@post2
      ).to have_no_link '詳細', href: post_path(@post2)
    end
    it 'ログインしていないと投稿の編集画面には遷移できない' do
      # トップページにいる
      visit root_path
      # 投稿1に「詳細」ボタンがないことを確認する
      expect(@post1
      ).to have_no_link '詳細', href: post_path(@post1)
      # 投稿2に「編集」ボタンがないことを確認する
      expect(@post2
      ).to have_no_link '詳細', href: post_path(@post2)
    end
  end
end

RSpec.describe '投稿削除', type: :system do
  before do
    @post1 = FactoryBot.create(:post)
    @post2 = FactoryBot.create(:post)
  end
  context '投稿削除ができるとき' do
    it 'ログインしたユーザーは自らが投稿した投稿の削除ができる' do
      # このテストを行うときは削除ボタンのアラートを消してから行う
     # 投稿1を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'Email', with: @post1.user.email
      fill_in 'Password', with: @post1.user.password
      find('input[name=commit').click
      expect(current_path).to eq root_path
     # 詳細ページへ遷移する
      visit post_path(@post1)
      # 投稿を削除するとレコードの数が1減ることを確認する
      click_button '削除する'
      change { Post.count }.by(-1)
      # トップページには投稿1の内容が存在しないことを確認する
      expect(page).to have_no_content("#{@post1.title}")
      # トップページには投稿1の内容が存在しないことを確認する
      expect(page).to have_no_content("#{@post1.rank1}")
      expect(page).to have_no_content("#{@post1.rank2}")
      expect(page).to have_no_content("#{@post1.rank3}")
    end
  end
  context '投稿削除ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿した投稿の削除ができない' do
      # 投稿1を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'Email', with: @post1.user.email
      fill_in 'Password', with: @post1.user.password
      find('input[name=commit').click
      expect(current_path).to eq root_path
      # 投稿2に「詳細」ボタンが無いことを確認する
      expect(@post2
      ).to have_no_link '詳細', href: post_path(@post2)
    end
  
    it 'ログインしていないと投稿の削除ボタンがない' do
      # トップページに移動する
      visit root_path
      # 投稿1に「詳細」ボタンが無いことを確認する
      expect(@post1
      ).to have_no_link '詳細', href: post_path(@post2)
      # 投稿2に「詳細」ボタンが無いことを確認する
      expect(@post2
      ).to have_no_link '詳細', href: post_path(@post2)
    end
  end
end

RSpec.describe '投稿詳細', type: :system do
  before do
    @post = FactoryBot.create(:post)
  end
  it 'ログインしたユーザーは投稿詳細ページに遷移してコメント投稿欄が表示される' do
    # ログインする
      visit new_user_session_path
      fill_in 'Email', with: @post.user.email
      fill_in 'Password', with: @post.user.password
      find('input[name=commit').click
      expect(current_path).to eq root_path
    # 詳細ページに遷移する
    click_button '詳細'
    # 詳細ページに投稿の内容が含まれている
    expect(page).to have_content("#{@post.title}")
    expect(page).to have_content("#{@post.rank1}")
    expect(page).to have_content("#{@post.rank2}")
    expect(page).to have_content("#{@post.rank3}")
    # コメント用のフォームが存在する
    expect(page).to have_selector 'form'
  end
  it 'ログインしていない状態でツイート詳細ページに遷移できるもののコメント投稿欄が表示されない' do
    # トップページに移動する
    visit root_path
    # 詳細ボタンを押す
    click_button '詳細'
    # 詳細ページに投稿の内容が含まれている
    expect(page).to have_content("#{@post.title}")
    expect(page).to have_content("#{@post.rank1}")
    expect(page).to have_content("#{@post.rank2}")
    expect(page).to have_content("#{@post.rank3}")
    # フォームが存在しないことを確認する
    expect(page).to have_no_selector 'form'
    # 「コメントの投稿には新規登録/ログインが必要です」が表示されていることを確認する
    expect(page).to have_content 'コメントの投稿には新規登録/ログインが必要です'
  end
end
