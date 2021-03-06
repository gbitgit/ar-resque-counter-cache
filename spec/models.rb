ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(:adapter  => 'sqlite3', :database => ':memory:')

class CreateModelsForTest < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string     :name
      t.integer    :posts_count, :default => 0
      t.integer    :comments_count, :default => 0
      t.integer    :dogs_count, :default => 0
    end
    create_table :posts do |t|
      t.string     :body
      t.belongs_to :user
      t.integer    :count_of_comments, :default => 0
    end
    create_table :comments do |t|
      t.string     :body
      t.belongs_to :user
      t.belongs_to :post
    end
    create_table :dogs do |t|
      t.string     :name
      t.belongs_to :user
    end
    create_table :cats do |t|
      t.string     :name
      t.belongs_to :user
    end
  end
  def self.down
    drop_table(:users)
    drop_table(:posts)
    drop_table(:comments)
    drop_table(:dogs)
    drop_table(:cats)
  end
end

class User < ActiveRecord::Base
  has_many :comments
  has_many :posts
  has_many :dogs
  has_many :cats
end

class Post < ActiveRecord::Base
  belongs_to :user, :async_counter_cache => true
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :user, :async_counter_cache => true
  belongs_to :post, :async_counter_cache => "count_of_comments"
end

# Old school counter cache.
class Dog < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
end

# No counter cache at all.
class Cat < ActiveRecord::Base
  belongs_to :user
end
