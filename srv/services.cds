using { sap.capire.incidents as my } from '../db/schema';

/**
 * Service used by support personell, i.e. the incidents' 'processors'.
 */
service ProcessorService @(requires:'support') {
  entity Incidents as projection on my.Incidents;
  entity Customers @readonly as projection on my.Customers;
}

/**
 * Service used by administrators to manage customers and incidents.
 */
service AdminService @(requires:'admin') {
  entity Customers as projection on my.Customers;
  entity Incidents as projection on my.Incidents;
}

annotate ProcessorService.Incidents with @changelog: [title] {
  conversation @changelog: [conversation.message];
}

// annotate ProcessorService.Incidents with @changelog: [title] {
//   customer @changelog: [customer.order.orderNumber, customer.order.shippingAddress];
// }

// annotate ProcessorService.Incidents with @changelog: [title] {
//   customer @changelog: [customer.addresses.city, customer.addresses.streetAddress];
// }

// annotate ProcessorService.Incidents with @changelog: [title] {
//   conversation @changelog: [conversation.message];
// }
