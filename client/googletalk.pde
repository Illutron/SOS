//package dk.liljedahl.christian.apx;

//import BotChatListener;
boolean listen = true;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Random;

import org.jivesoftware.smack.Chat;
import org.jivesoftware.smack.ChatManager;
import org.jivesoftware.smack.ConnectionConfiguration;
import org.jivesoftware.smack.MessageListener;
import org.jivesoftware.smack.PacketListener;
import org.jivesoftware.smack.Roster;
import org.jivesoftware.smack.RosterEntry;
import org.jivesoftware.smack.XMPPConnection;
import org.jivesoftware.smack.XMPPException;
import org.jivesoftware.smack.filter.MessageTypeFilter;
import org.jivesoftware.smack.filter.PacketFilter;
import org.jivesoftware.smack.packet.IQ;
import org.jivesoftware.smack.packet.Message;
import org.jivesoftware.smack.packet.Packet;
import org.jivesoftware.smack.packet.Presence;
import org.jivesoftware.smack.util.StringUtils;

//import dk.liljedahl.christian.apx.shipdaemon.IncomingMessageParser;
//import dk.liljedahl.christian.apx.shipdaemon.Mediator;


public class XMPPMachine {

  private String _LocalUsername;
  private String _LocalPassword;

  //        public static boolean listen = true;

  // static Mediator myMediator;

  /**
   * @param _LocalUsername
   * @param _LocalPassword
   */
  public XMPPMachine(String _LocalUsername, String _LocalPassword) {
    this._LocalUsername = _LocalUsername;
    this._LocalPassword = _LocalPassword;
  }

  /*   public XMPPMachine(Mediator mediator) {
   XMPPMachine.myMediator = mediator;
   }*/

  public XMPPMachine() {
  }


  public String get_LocalUsername() {
    return _LocalUsername;
  }
  public void set_LocalUsername(String _LocalUsername) {
    this._LocalUsername = _LocalUsername;
  }
  public String get_LocalPassword() {
    return _LocalPassword;
  }
  public void set_LocalPassword(String _LocalPassword) {
    this._LocalPassword = _LocalPassword;
  }

  private ConnectionConfiguration config;
  private XMPPConnection connection;

  public  class MessageHandler implements PacketListener {
    public MessageHandler(XMPPConnection conn) {
    }

    public void processPacket(Packet packet) {

      // Are we allowed to listen?
      if (listen) {
        Message message = (Message)packet;
        if (message.getBody() != null) {
          //         IncomingMessageParser incomingMessageParser = new IncomingMessageParser(myMediator);
          //         incomingMessageParser.ParseMessage(message);
           parseChat(message.getBody());
        }
      }
    }
  };

  public void sendPacket(Message reply) {
    connection.sendPacket(reply);
  }
  public XMPPConnection openconnection() {         

    // TODO IF we already are connected, we don't want to do it again - Just login a different user
    // This is the connection to google talk. If you use jabber, put other stuff in here. 
    config = new ConnectionConfiguration("talk.google.com", 5222, "gmail.com");

    connection = new XMPPConnection(config);

    try {
      connection.connect();

      // Google password has to be of _strong_ quality to work
      connection.login(_LocalUsername, _LocalPassword);
      Presence presence = new Presence(Presence.Type.available);
      connection.sendPacket(presence);
    } 
    catch (XMPPException e) {
      e.printStackTrace();
    }

    if (connection.isConnected()) {

      // We got connected, so we can now attach the listener
      PacketFilter filter = new MessageTypeFilter(Message.Type.chat);
      connection.addPacketListener(new MessageHandler(connection), filter);

      return connection;
    }
    return null;
  }       

  public String getAllFriendsS() {
    String rs = "";

    Roster roster = connection.getRoster();
    Collection<RosterEntry> entries = roster.getEntries();
    for (RosterEntry entry : entries) {
      rs += entry.getUser() + "\n";
    }
    return rs;
  }
  public ArrayList<String> getAllFriends() {
    ArrayList<String> Users = new ArrayList<String>();

    Roster roster = connection.getRoster();
    Collection<RosterEntry> entries = roster.getEntries();
    for (RosterEntry entry : entries) {
      Users.add(entry.getUser());
    }
    return Users;
  }

  public void SendToAllFriends(String message) {

    // Send to all my friends
    Roster roster = connection.getRoster();
    Collection<RosterEntry> entries = roster.getEntries();

    String replyText = message;


    for (RosterEntry entry : entries) {
      Message reply = new Message();
      reply.setType(Message.Type.chat);
      reply.setBody(replyText);
      String toName = entry.getUser(); 
      reply.setTo(toName);
      sendPacket(reply);
    }
  }
  public void SendToFriend(String message, String friendEmail) {

    // Send to one friends
    String replyText = message;

    Message reply = new Message();
    reply.setType(Message.Type.chat);
    reply.setBody(replyText);
    String toName = friendEmail; 
    reply.setTo(toName);
    sendPacket(reply);
  }

  public void SendFriendRequest(String friendEmail) {
    Roster roster = connection.getRoster();
    if (!friendEmail.equals("")) {
      try {
        roster.createEntry(friendEmail, friendEmail, null);
      } 
      catch (XMPPException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }               
    // Really, we just send a message
  }

  public void removeFriend(String friendEmail) {
    Roster roster = connection.getRoster();
    if (!friendEmail.equals("")) {
      try {

        roster.removeEntry(roster.getEntry(friendEmail));
      } 
      catch (XMPPException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }               
    // Really, we just send a message
  }

  public void closeconnection() {
    connection.disconnect();
  }
}

