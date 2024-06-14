#Moved gateway resource in version 1.4.2 because of conditionality
moved {
  from = aviatrix_gateway.default
  to   = aviatrix_gateway.default[0]
}
