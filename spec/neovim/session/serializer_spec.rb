require "socket"
require "helper"

module Neovim
  class Session
    RSpec.describe Serializer do
      shared_context "serializer behavior" do
        it "sends and receives data" do
          serializer = Serializer.new(event_loop)
          request = nil

          server_thread = Thread.new do
            client = server.accept
            request = client.readpartial(1024)

            client.write(MessagePack.pack(["res"]))
            client.close
            server.close
          end

          response = nil
          serializer.write(["req"]).run do |message|
            response = message
            serializer.shutdown
          end

          server_thread.join
          expect(request).to eq(MessagePack.pack(["req"]))
          expect(response).to eq(["res"])
        end
      end

      context "tcp" do
        let!(:server) { TCPServer.new("0.0.0.0", 0) }
        let!(:event_loop) { EventLoop.tcp("0.0.0.0", server.addr[1]) }

        include_context "serializer behavior"
      end

      context "unix" do
        let!(:server) { UNIXServer.new(Support.socket_path) }
        let!(:event_loop) { EventLoop.unix(Support.socket_path) }

        include_context "serializer behavior"
      end

      describe "#run" do
        it "logs exceptions" do
          unpacker = instance_double(MessagePack::Unpacker)
          event_loop = instance_double(EventLoop)
          serializer = Serializer.new(event_loop, unpacker)

          expect(event_loop).to receive(:run).and_yield("data")
          expect(unpacker).to receive(:feed_each).with("data").and_raise("BOOM")
          expect(serializer).to receive(:fatal).with(/BOOM/)

          serializer.run
        end
      end
    end
  end
end
