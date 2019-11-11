class Fugen < Formula
  desc "A Swift command line tool to generate code from Figma files"
  homepage "https://github.com/almazrafi/Fugen"
  url "https://github.com/almazrafi/Fugen/archive/1.0.0-alpha.3.tar.gz"
  sha256 "776bac2ab82faf5e499a8273acea853bc5e337d271545b8d55e5e72b9c9082d2"
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
