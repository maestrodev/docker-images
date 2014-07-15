class maestro_nodes::mail(
  $from_name,
  $from_address,
) {
  $mail_from = {
    name    => $from_name,
    address => $from_address,
  }
}
