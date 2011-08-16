require 'helper'
require 'tempfile'

class TestBioOrthomcl < Test::Unit::TestCase
  include Bio
  
  # Convert a String to an IO object and return it (why is there no String#to_io method?)
  # and give a Tempfile within a block
  def mock_io(string)
#    lambda do
      Tempfile.open('bio-og_test') do |tempfile|
        tempfile.puts string
        tempfile.close
        yield File.open(tempfile.path)
#      end
    end
  end
  
  should "convert_groups_file_to_gene_id_to_group_id_hash" do
    string = <<EOF
OG4_1: bbov|gene1
OG4_2: bbov|gene3 pfal|gene1
EOF
    mock_io(string) do |io|
      answer = {
      'bbov|gene1' => 'OG4_1',
      'bbov|gene3' => 'OG4_2',
      'pfal|gene1' => 'OG4_2',
      }
      assert_equal answer, OrthoMCL.convert_groups_file_to_gene_id_to_group_id_hash(io)
    end
    
    mock_io(string) do |io|
      answer = {
      'bbov|gene1' => 'OG4_1',
      'bbov|gene3' => 'OG4_2',
      }
      assert_equal answer, OrthoMCL.convert_groups_file_to_gene_id_to_group_id_hash(io, 'bbov')
    end
  end
end
