require "helper"

module Neovim
  RSpec.describe RemoteObject do
    context Window do
      let(:window) { Neovim.attach_child(["-n", "-u", "NONE"]).current.window }

      describe "#respond_to?" do
        it "returns true for Window functions" do
          expect(window).to respond_to(:get_cursor)
        end

        it "returns true for Ruby functions" do
          expect(window).to respond_to(:inspect)
        end

        it "returns false otherwise" do
          expect(window).not_to respond_to(:foobar)
        end
      end

      describe "#method_missing" do
        it "enables window_* function calls" do
          expect(window.get_cursor).to eq([1, 0])
        end
      end

      describe "#methods" do
        it "returns builtin methods" do
          expect(window.methods).to include(:inspect)
        end

        it "returns api methods" do
          expect(window.methods).to include(:get_height)
        end
      end
    end

    context Tabpage do
      let(:tabpage) { Neovim.attach_child(["-n", "-u", "NONE"]).current.tabpage }

      describe "#respond_to?" do
        it "returns true for Tabpage functions" do
          expect(tabpage).to respond_to(:is_valid)
        end

        it "returns true for Ruby functions" do
          expect(tabpage).to respond_to(:inspect)
        end

        it "returns false otherwise" do
          expect(tabpage).not_to respond_to(:foobar)
        end
      end

      describe "#method_missing" do
        it "enables tabpage_* function calls" do
          expect(tabpage.is_valid).to be(true)
        end
      end

      describe "#methods" do
        it "returns builtin methods" do
          expect(tabpage.methods).to include(:inspect)
        end

        it "returns api methods" do
          expect(tabpage.methods).to include(:get_windows)
        end
      end
    end

    context Buffer do
      let(:buffer) { Neovim.attach_child(["-n", "-u", "NONE"]).current.buffer }

      describe "#respond_to?" do
        it "returns true for Buffer functions" do
          expect(buffer).to respond_to(:line_count)
        end

        it "returns true for Ruby functions" do
          expect(buffer).to respond_to(:inspect)
        end

        it "returns false otherwise" do
          expect(buffer).not_to respond_to(:foobar)
        end
      end

      describe "#method_missing" do
        it "enables buffer_* function calls" do
          expect(buffer.line_count).to be(1)
        end
      end

      describe "#methods" do
        it "returns builtin methods" do
          expect(buffer.methods).to include(:inspect)
        end

        it "returns api methods" do
          expect(buffer.methods).to include(:get_mark)
        end
      end
    end
  end
end