class Aidlc < Formula
  desc "Initialize and update AIDLC governance files"
  homepage "https://github.com/shubhangtiwari/aidlc"
  url "https://github.com/shubhangtiwari/aidlc/archive/refs/tags/aidlc/v0.8.1.tar.gz"
  sha256 "019b6fa6ca7bbb397f4711d1e225143c70d49268a33a78b142ffe1cf61556310"
  license "MIT"

  depends_on "go" => :build

  def install
    cd "aidlc" do
      ldflags = "-s -w -X github.com/shubhangtiwari/aidlc/aidlc/internal/commands.Version=#{version}"
      system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/aidlc"
    end
  end

  test do
    assert_match "aidlc #{version}", shell_output("#{bin}/aidlc version")
  end
end
