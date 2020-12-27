require 'rails_helper'

def basic_pass(path)
  username = ENV['BASIC_AUTH_USER']
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      basic_pass new_user_session_path
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'Name', with: @user.name
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Profile', with: @user.profile
      FactoryBot.create(:user, :with_picture)
      # サインアップボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect  do
        find('input[name="commit"]').click
      end.to change { User.count }.by(1)
      # トップページへ遷移する
      expect(current_path).to eq root_path
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end

  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      basic_pass new_user_session_path
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'Name', with: ''
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      fill_in 'Profile', with: ''
      FactoryBot.create(:user, :with_picture)
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect  do
        find('input[name="commit"]').click
      end.to change { User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq '/users'
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ログインができるとき' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      # トップページに移動する
      basic_pass new_user_session_path
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ログインができないとき' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      # トップページに移動する
      basic_pass new_user_session_path
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻されることを確認する
      expect(current_path).to eq new_user_session_path
    end
  end
end

RSpec.describe 'ユーザー情報編集', type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
  end

  context 'ユーザー情報が更新できる時' do
    it '更新したい情報が正しく、保存できている' do
      # Basic認証を通過し、ログインページに移動する
      basic_pass new_user_session_path
      visit new_user_session_path
      # 正しいユーザー1の情報を入力する
      fill_in 'Email', with: @user1.email
      fill_in 'Password', with: @user1.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
       # ユーザーページへ遷移する
      visit user_path(@user1)
      # 編集するボタンをクリック
      click_button 'プロフィールを変更'
      # すでに記載済みの内容がフォームに入っていることを確認する
      expect(
        find('#user_name').value
      ).to eq @user1.name
      expect(
        find('#user_profile').value
      ).to eq @user1.profile
      # 投稿内容を編集する
      fill_in 'user_name', with: @user1.name
      fill_in 'user_profile', with: @user1.profile
      FactoryBot.create(:user, :with_picture)
      # 編集してもUserモデルのカウントは変わらないことを確認する
      expect  do
        find('input[name="commit"]').click
      end.to change { User.count }.by(0)
      # ユーザーページに遷移していることを確認する
      expect(current_path).to eq user_path(@user1)
      # トップページには先ほど変更した内容の投稿が存在することを確認する
      expect(page).to have_content(@user1.name)
      expect(page).to have_content(@user1.profile)
      expect(page).to have_content(@user1.image)
    end
  end

  context 'ユーザー情報編集ができないとき' do

    it 'ユーザー１はユーザー２の情報を変更できない' do
      # ユーザー１でログインする
      basic_pass new_user_session_path
      visit new_user_session_path
      fill_in 'Email', with: @user1.email
      fill_in 'Password', with: @user1.password
      find('input[name=commit').click
      expect(current_path).to eq root_path
      # ユーザー２の詳細ページへ遷移する
      visit user_path(@user2)
      # ユーザー２の詳細ページにはプロフィールを変更ボタンがないことを確認
      expect(page).to have_no_button 'プロフィールを変更'
    end

    it 'ユーザー情報を正しく入力しないと変更できない' do
       # ユーザー１でログインする
       basic_pass new_user_session_path
       visit new_user_session_path
       fill_in 'Email', with: @user1.email
       fill_in 'Password', with: @user1.password
       find('input[name=commit').click
       expect(current_path).to eq root_path
      # ユーザーページへ遷移する
      visit user_path(@user1)
      # 編集するボタンをクリック
      click_button 'プロフィールを変更'
      # すでに記載済みの内容がフォームに入っていることを確認する
      expect(
        find('#user_name').value
      ).to eq @user1.name
      expect(
        find('#user_profile').value
      ).to eq @user1.profile
      # 投稿内容を不完全な状態で編集する
      fill_in 'user_name', with: ''
      fill_in 'user_profile', with: ''
      FactoryBot.create(:user, :with_picture)
      # ユーザーモデル数が変わっていないことを確認する
      expect  do
        find('input[name="commit"]').click
      end.to change { User.count }.by(0)
      # ユーザー情報変更画面のままのことを確認する
      expect(current_path).to eq user_registration_path
    end
  end
end

RSpec.describe 'フォロー機能', type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
  end

  context '正しくフォロー、フォロー解除できる場合' do
    it 'ユーザー１でログインし、ユーザー２をフォローし、双方のリストから格ユーザーを確認できる' do
      # Basic認証を通過し、ログインページに移動する
      basic_pass new_user_session_path
      visit new_user_session_path
      # 正しいユーザー1の情報を入力する
      fill_in 'Email', with: @user1.email
      fill_in 'Password', with: @user1.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # ユーザー2のユーザーページへ遷移する
      visit user_path(@user2)
      # フォローボタンをクリック
      click_button 'フォロー'
      # フォロワーをクリック
      click_on('フォロワー')
      # ユーザー１を確認できる
      expect(page).to have_content(@user1.name)
      # ユーザー１のユーザーページへ遷移する
      visit user_path(@user1)
      # ユーザー１のフォローをクリック
      click_on('フォロー')
      # ユーザー２を確認できる
      expect(page).to have_content(@user2.name)
      # ユーザー２のユーザーページへ遷移
      visit user_path(@user2)
      # ユーザー２のフォローを外すボタンをクリック
      click_button 'フォローを外す'
      # ユーザー２のフォロワーをクリックし、ユーザー１が居ないことを確認
      click_on('フォロワー')
      expect(page).to have_no_content(@user1.name)
      # ユーザー１のユーザーページへ遷移し、フォローをクリック
      visit user_path(@user1)
      click_on('フォロー')
      # ユーザー２が居ないことを確認
      expect(page).to have_no_content(@user2.name)
    end
  end

  context '正しく機能しない場合' do

    it 'ログインしていないとフォローできない' do
      # Basic認証を通過後、トップページへ
      basic_pass new_user_session_path
      visit root_path
      # ユーザー２の詳細画面へ
      visit user_path(@user2)
      # 画面にフォローボタンがないことを確認
      expect(page).to have_no_button 'フォロー'
    end
  end
end


