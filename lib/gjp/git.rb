# encoding: UTF-8

module Gjp
  # facade to git, currently implemented with calls to the git command
  # prefixes all tags with "gjp_"
  class Git
    include Logger

    # inits a new git manager object pointing to the specified
    # directory
    def initialize(directory)
      @directory = directory
    end

    # inits a repo
    def init
      Dir.chdir(@directory) do
        if Dir.exists?(".git") == false
          `git init`
        else
          raise GitAlreadyInitedException
        end
      end
    end

    # returns a list of filenames that changed in the repo
    # since the specified tag
    def changed_files_since(tag)
      Dir.chdir(@directory) do
        `git diff-tree --no-commit-id --name-only -r gjp_#{tag} HEAD`.split("\n")
      end
    end

    # adds all files in the current directory and removes
    # all files not in the current directory.
    # if tag is given, commit is also tagged
    def commit_whole_directory(message, tag = nil)
      Dir.chdir(@directory) do
        log.debug "committing with message: #{message}"

        `git rm -r --cached --ignore-unmatch .`
        `git add .`
        `git commit -m "#{message}"`

        if tag != nil
          `git tag gjp_#{tag}`
        end
      end
    end

    # returns the highest suffix found in tags with the given prefix
    def get_tag_maximum_suffix(prefix)
      Dir.chdir(@directory) do
        `git tag`.split.map do |tag|
          if tag =~ /^gjp_#{prefix}_([0-9]+)$/
            $1.to_i
          else
            0
          end
         end.max or 0
      end
    end

    # reverts path contents as per specified tag
    def revert_whole_directory(path, tag)
      Dir.chdir(@directory) do
        `git rm -rf --ignore-unmatch #{path}`
        `git checkout -f gjp_#{tag} -- #{path}`

        `git clean -f -d #{path}`
      end
    end

    # 3-way merges the git file at path with the one in new_path
    # assuming they have a common ancestor at the specified tag
    def merge_with_tag(path, new_path, tag)
      Dir.chdir(@directory) do
        `git show gjp_#{tag}:#{path} > #{path}.old_version`
        `git merge-file --ours #{path} #{path}.old_version #{new_path}`
        File.delete "#{path}.old_version"
      end
    end

    # deletes a tag
    def delete_tag(tag)
      Dir.chdir(@directory) do
        `git tag -d gjp_#{tag}`
      end
    end
  end

  class GitAlreadyInitedException < Exception
  end
end
