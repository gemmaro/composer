(use-modules (gnu packages php)
             (gnu packages gettext)
             (gnu packages node)
             (gemmaro packages mdbook))

(packages->manifest (list php po4a node-lts))
