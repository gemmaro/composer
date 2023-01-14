(use-modules (gnu packages php)
             (gnu packages gettext)
             (gnu packages node))

(packages->manifest (list php po4a node-lts))
