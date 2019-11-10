class Fugen < Formula
  desc "A Swift command line tool to generate code from Figma files"
  homepage "https://github.com/almazrafi/Fugen"
  url "https://github.com/almazrafi/Fugen/archive/1.0.0-alpha.1.tar.gz"
  sha256 "0f99d74f533f3b458adda587f59293fb6faa6259216ca9a6344cf605268c558a"
  head "https://github.com/almazrafi/Fugen.git"

  depends_on :xcode

  def install
    if OS::Mac::Xcode.version >= Version.new("10.0") && !OS::Mac::Xcode.without_clt? then
      old_isystem_paths = ENV["HOMEBREW_ISYSTEM_PATHS"]
      ENV["HOMEBREW_ISYSTEM_PATHS"] = old_isystem_paths.gsub("/usr/include/libxml2", "")
    end

    system "make", "install", "PREFIX=#{prefix}"

    ENV["HOMEBREW_ISYSTEM_PATHS"] = old_isystem_paths if defined? old_isystem_paths
  end
end
