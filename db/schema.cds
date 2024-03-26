using { cuid, managed, sap.common.CodeList, User } from '@sap/cds/common';

namespace sap.capire.incidents;

/**
 * Customers using products sold by our company.
 * Customers can create support Incidents.
 */
entity Customers : cuid, managed {
  key ID         : String;
  firstName      : String;
  lastName       : String;
  name           : String = firstName ||' '|| lastName;
  email          : EMailAddress;
  phone          : PhoneNumber;
  creditCardNo   : String(16) @assert.format: '^[1-9]\d{15}$';
  // order          : Association to Orders;
  // addresses      : Composition of many Addresses on addresses.customer = $self;
  addresses      : Association to Addresses;
  incidents      : Association to many Incidents on incidents.customer = $self;
}

// entity Orders : cuid, managed {
//   customer       : Association to Customers;
//   orderNumber    : String @title: 'Order Number';
//   orderDate      : DateTime @title: 'Order Date';
//   totalAmount    : Decimal @title: 'Total Amount';
//   shippingAddress: String @title: 'Shipping Address';
// }

entity Addresses : cuid, managed {
  customer       : Association to Customers;
  city           : String;
  postCode       : String;
  streetAddress  : String;
}


/**
 * Incidents created by Customers.
 */

// aspect conversation: managed, cuid {
//     key ID    : UUID;
//     timestamp : type of managed:createdAt;
//     author    : type of managed:createdBy;
//     message   : String;
// }

entity Incidents : cuid, managed {
  customer       : Association to Customers;
  title          : String @title: 'Title';
  urgency        : Association to Urgency default 'M';
  status         : Association to Status default 'N';
  // conversation   : Composition of many conversation;
  conversation   : Composition of many {
    key ID    : UUID;
    timestamp : type of managed:createdAt;
    author    : type of managed:createdBy;
    message   : String;
  };
  // conversation : Composition of many {
  //   key ID    : UUID;
  //   // timestamp : type of managed:createdAt;
  //   // author    : type of managed:createdBy;
  //   timestamp : type of managed:createdAt @cds.on.insert : $now @cds.on.update : $now;
  //   author    : type of managed:createdBy @cds.on.insert : $user @cds.on.update : $user;
  //   message   : String;
  //   modifiedAt : Timestamp @cds.on.insert : $now  @cds.on.update : $now;
  //   modifiedBy : User      @cds.on.insert : $user @cds.on.update : $user;
  // };
}

// entity conversation : managed, cuid {
//     key ID    : UUID;
//     timestamp : type of managed:createdAt;
//     author    : type of managed:createdBy;
//     message   : String;
//     incidents : Association to one Incidents;
// }

// annotate Incidents with {
//   conversation @changelog: [conversation.author, conversation.message];
// };


entity Status : CodeList {
  key code    : String enum {
    new        = 'N';
    assigned   = 'A';
    in_process = 'I';
    on_hold    = 'H';
    resolved   = 'R';
    closed     = 'C';
  };
  criticality : Integer;
}

entity Urgency : CodeList {
  key code : String enum {
    high   = 'H';
    medium = 'M';
    low    = 'L';
  };
}

type EMailAddress : String;
type PhoneNumber  : String;
