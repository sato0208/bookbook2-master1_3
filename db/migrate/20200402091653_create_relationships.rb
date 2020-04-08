class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
	  # 外部キーとしての設定をするためにオプションは「foreign_key: true」
	  t.references :user, foreign_key: true
	  # follow_idの参照先のテーブルはusersテーブルにする
      t.references :follow, foreign_key: { to_table: :users }

      t.timestamps
      # follow_id のペアで重複するものが保存されないようにするデータベースの設定
      t.index [:user_id, :follow_id], unique: true
    end
  end
end
