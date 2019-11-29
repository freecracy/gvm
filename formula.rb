# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Watermark < Formula
  desc "gvm"
  homepage "https://github.com/freecracy/gvm"
  url "https://raw.githubusercontent.com/freecracy/gvm/master/gvm"
  # sha256 "69d29344184dbb38c45a820823fee7c1f316100d7d7ba15f99df0a02f89b9efe"
  # depends_on "cmake" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    # system "./configure", "--disable-debug",
                          # "--disable-dependency-tracking",
                          # "--disable-silent-rules",
                          # "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    mv gvm "#{bin}/gvm" 
    #bin.install "gvm"
    # system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test news`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
