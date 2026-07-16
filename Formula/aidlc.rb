class Aidlc < Formula
  desc "Initialize and update AIDLC governance files"
  homepage "https://github.com/shubhangtiwari/aidlc"
  url "https://github.com/shubhangtiwari/aidlc/archive/refs/tags/aidlc/v0.12.0.tar.gz"
  sha256 "69f61bbe5f2c4b57560335681ecebeeabc804350763f0e14abe08e8320db8ca7"
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
