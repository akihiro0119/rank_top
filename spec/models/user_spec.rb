require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー新規登録' do
    before do
      @user = FactoryBot.build(:user)
    end
    context '新規登録がうまくいく時' do
      it '全ての入力が正しく行われている' do
        expect(@user).to be_valid
      end
    end

    context '新規登録がうまくいかない時' do
      it 'nameが空だと登録できない' do
        @user.name = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("お名前を入力してください")
      end
      it 'emailが既に存在していると登録できない' do
        @user.save
        another_user = FactoryBot.build(:user, email: @user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Eメールはすでに存在します')
      end
      it 'emailが空では登録できない' do
        @user.email = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Eメールを入力してください")
      end
      it 'emailに@が含まれていないと登録ができない' do
        @user.email = 'aaaaaaa'
        @user.valid?
        expect(@user.errors.full_messages).to include('Eメールは不正な値です')
      end
      it 'passwordが空では登録できない' do
        @user.password = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワードを入力してください")
      end
      it 'passwordが５文字以下では登録ができない' do
        @user.password = 'aaa11'
        @user.password_confirmation = 'aaa11'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは6文字以上で入力してください', "パスワードに半角英数字を使用してください")
      end
      it 'passwordが英字のみでは登録できない' do
        @user.password = 'aaaaaa'
        @user.password_confirmation = 'aaaaaa'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードに半角英数字を使用してください')
      end
      it 'passwordが数字のみでは登録できない' do
        @user.password = '111111'
        @user.password_confirmation = '111111'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードに半角英数字を使用してください')
      end
      it 'passwordが全角では登録できない' do
        @user.password = 'ａｂｃ１２３'
        @user.password_confirmation = 'ａｂｃ１２３'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードに半角英数字を使用してください')
      end
      it 'profileが空だと登録できない' do
        @user.profile = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("プロフィールを入力してください")
      end
      it 'profileが301文字以上だと登録できない' do
        @user.profile = 'あ' * 301
        @user.valid?
        expect(@user.errors.full_messages).to include('プロフィールは300文字以内で入力してください')
      end
      it 'nameが20文字以上だと登録できない' do
        @user.name = 'あ' * 21
        @user.valid?
        expect(@user.errors.full_messages).to include('お名前は20文字以内で入力してください')
      end
    end
  end
end
