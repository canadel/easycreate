require 'helper'

describe "Special locals (_file_ and friends)" do
  it 'locals should all exist upon initialization' do
    mock_pry("_file_").should.not =~ /NameError/
    mock_pry("_dir_").should.not =~ /NameError/
    mock_pry("_ex_").should.not =~ /NameError/
    mock_pry("_pry_").should.not =~ /NameError/
    mock_pry("_").should.not =~ /NameError/
  end

  it 'locals should still exist after cd-ing into a new context' do
    mock_pry("cd 0", "_file_").should.not =~ /NameError/
    mock_pry("cd 0","_dir_").should.not =~ /NameError/
    mock_pry("cd 0","_ex_").should.not =~ /NameError/
    mock_pry("cd 0","_pry_").should.not =~ /NameError/
    mock_pry("cd 0","_").should.not =~ /NameError/
  end

  it 'locals should keep value after cd-ing(_pry_ and _ex_)' do
    mock_pry("$x = _pry_;", "cd 0", "_pry_ == $x").should =~ /true/
    mock_pry("error blah;", "$x = _ex_;", "cd 0", "_ex_ == $x").should =~ /true/
  end

  it 'locals should keep value after cd-ing (_file_ and _dir_)' do
    Pry.commands.command "file-and-dir-test" do
      set_file_and_dir_locals("/blah/ostrich.rb")
    end

    mock_pry("file-and-dir-test", "cd 0", "_file_").should =~ /\/blah\/ostrich\.rb/
    a = mock_pry("file-and-dir-test", "cd 0", "_dir_").should =~ /\/blah/
    Pry.commands.delete "file-and-dir-test"
  end

end
