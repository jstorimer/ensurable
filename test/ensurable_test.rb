require 'helper'

class EnsurableTest < MiniTest::Unit::TestCase
  def test_noops_if_rails_env_is_production
    Rails.env = 'production'

    Ensurable.expects(:instance_eval).never
    Ensurable.ensure {}

    Rails.env = nil
  end

  def test_works_if_rails_env_is_development
    Rails.env = 'development'

    Ensurable.expects(:instance_eval)
    Ensurable.ensure {}
  end

  def test_noop_if_rails_env_var_is_production
    ENV['RAILS_ENV'] = 'production'

    Ensurable.expects(:instance_eval).never
    Ensurable.ensure {}

    ENV['RAILS_ENV'] = nil
  end

  def test_noop_if_rack_env_var_is_production
    ENV['RACK_ENV'] = 'production'

    Ensurable.expects(:instance_eval).never
    Ensurable.ensure {}

    ENV['RACK_ENV'] = nil
  end

  def test_ensure_with_git_installed
    Ensurable::Git.any_instance.expects(:installed?).returns(true)

    Ensurable.ensure do
      installed 'git'
    end
  end

  def test_ensure_without_git_installed
    Ensurable::Git.any_instance.expects(:installed?).returns(false)

    assert_raises(Ensurable::NotInstalled) {
      Ensurable.ensure do
        installed 'git'
      end
    }
  end

  def test_ensure_with_redis_running
    Ensurable::Redis.any_instance.expects(:running?).returns(true)

    Ensurable.ensure do
      running 'redis'
    end
  end

  def test_ensure_without_redis_running
    Ensurable::Redis.any_instance.expects(:running?).returns(false)

    assert_raises(Ensurable::NotRunning) {
      Ensurable.ensure do
        running 'redis'
      end
    }
  end

  def test_ensure_with_file_arg_passed
    Ensurable::Git.any_instance.expects(:installed?).returns(true)

    file = File.new('ensure.rb', 'w+')
    file.puts "installed 'git'"
    file.seek(0)

    Ensurable.ensure(file)

    File.delete(file.path)
  end
end
