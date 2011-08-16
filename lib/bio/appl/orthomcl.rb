module Bio
  class OrthoMCL
    # Given an OrthoMCL groups IO object, perhaps created by Zlib::GzipReader.open('groups_OrthoMCL-5.txt.gz') 
    # where the 'groups_OrthoMCL-5.txt.gz' file was downloaded from
    # http://orthomcl.org/common/downloads/release-5/groups_OrthoMCL-5.txt.gz
    #
    # Optionally, a species_code string (e.g. 'bbov' for Babesia bovis) can be specified. If that is the
    # case, then only those genes that are from that species are returned as keys in the hash.
    #
    # In all cases, a hash is returned, containing gene IDs (e.g. 'pfal|PFI1600w') as keys, 
    # and their corresponding OrthoMCL group IDs as values (e.g. OG5_128452).
    def self.convert_groups_file_to_gene_id_to_group_id_hash(orthomcl_groups_io, species_code = nil)
      hash = {}
      
      orthomcl_groups_io.each_line do |line|
        line.chomp! unless line.nil? #is it ever nil?
        next if !line or line === '' #skip blank lines
        
        splits1 = line.split(': ')
        if splits1.length != 2
          raise Exception, "Bad line: #{line}"
        end
        
        group_id = splits1[0]
        splits1[1].split(' ').each do |gene_id|
          # If this gene ID does not find
          if !species_code.nil? and !gene_id.match(/^#{species_code}/)
            next
          end
          
          if hash[gene_id]
            $stderr.puts "Ignoring duplicate gene ID #{gene_id} from OrthoMCL group #{group_id}"
          else
            hash[gene_id] = group_id
          end
        end
      end
      return hash
    end
  end
end
