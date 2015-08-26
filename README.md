MeshPipe
========
By [Nevyn Bengtsson](mailto:nevyn.jpg@gmail.com), 2015-08-09

MeshPipe is an [IPC (inter-process communication)][IPC] library for iOS using
[UDP networking][UDP]. It allows multiple running applications on a single iOS
device to send arbitrary data to each other. It:

* Automatically connects to all other MeshPipe apps that are configured with the
  same port
* Detects when other apps disconnect or disappear, giving you a list of available
  peers

Since it is based on UDP, there are some hard-wired limitations:

* Message must fit within a single UDP datagram. The current UDP datagram max
  size on iOS is 9216 bytes.
* Delivery is not guaranteed. Messages may or may not get through, may arrive from seemingly unavailable peers, or arrive out of order.
* You may receive malicious or unexpected data, as any app on the phone could craft a message and send it to your app.
* Communication is insecure, and any app on the device might listen in or even change messages.

[IPC]: https://en.wikipedia.org/wiki/Inter-process_communication
[UDP]: https://en.wikipedia.org/wiki/User_Datagram_Protocol

Usage
=====

Start out by selecting a port, and the maximum number of participating apps.

Each app will try to connect to `count` other apps, so don't make this number too
large as it will create a very large number of UDP sockets.

Try somehow to choose a port and range that does not overlap with other apps'
usage of UDP or MeshPipe. Perhaps we can coordinate usage on the wiki for this
project?

Each app can also identify itself with a name. I suggest using
"\(appBundleName).\(nameOfLibrary)".

	_pipe = [[MeshPipe alloc] initWithBasePort:12568 count:8 peerName:name delegate:self];

When other peers have connected, you can talk to them like so:

	[peer sendData:[@"Hello" dataUsingEncoding:NSUTF8StringEncoding]];

Implement the delegate method to receive data:

	- (void)meshPipe:(MeshPipe*)pipe receivedData:(NSData*)data fromPeer:(MeshPipePeer*)peer

You can broadcast to all peers (i e all other connected apps) by enumerating the
connected peers:

	for(MeshPipePeer *peer in pipe.peers)
		[peer sendData:[@"Hello" dataUsingEncoding:NSUTF8StringEncoding]];

You can KVO on `peers`, or if you prefer, implement delegate methods for callbacks
when peers connect/disappear:

	- (void)meshPipe:(MeshPipe*)pipe acceptedNewPeer:(MeshPipePeer*)peer
	- (void)meshPipe:(MeshPipe *)pipe lostPeer:(MeshPipePeer*)peer withError:(NSError*)error

Note that on disconnection, the errors are in the `MeshPipeErrorDomain` domain
and are listed at the bottom of MeshPipe.h.

Usage with Cerfing
==================

If you want to shuffle more fun kinds of data around a MeshPipe network, you can
use Cerfing, and the attached CerfingMeshPipeTransport.See the Transport target's
main.m for a demo.

