#!/usr/bin/env racket

#lang racket

(require odysseus)
(require tabtree)
(require tabtree/utils)

(define places_tt
  (t+
    (parse-tabtree "/home/denis/projects/milk_industry_kgr/source/facts/places_russia.tree")
    (parse-tabtree "/home/denis/projects/milk_industry_kgr/source/facts/places_russia_smaller.tree")
    (parse-tabtree "/home/denis/projects/milk_industry_kgr/source/facts/places_ldnr.tree")
    (parse-tabtree "/home/denis/projects/milk_industry_kgr/source/facts/places_world.tree")))

(define known_places (hash-keys places_tt))

(define places_without_coors (->> places_tt
                                  hash-values
                                  (filter (λ (item) (equal? ($ a item) "loc/City")))
                                  (filter-not (λ (item) (and ($ lon item) ($ lat item))))
                                  (map (λ (item) ($ __id item)))))

; (define places_without_pop (->> places_tt
;                                 hash-values
;                                 (filter (λ (item) (equal? ($ a item) "loc/City")))
;                                 (filter-not (λ (item) (and ($ pop item))))
;                                 (map (λ (item) ($ __id item)))))

(define objects_places (->>
                          (t+
                            (parse-tabtree "/home/denis/projects/milk_industry_kgr/source/facts/factories.tree")
                            (parse-tabtree "/home/denis/projects/milk_industry_kgr/source/facts/factories_tare.tree")
                            (parse-tabtree "/home/denis/projects/milk_industry_kgr/source/facts/factories_equipment.tree")
                            )
                          hash-values
                          (map (λ (item) ($ place item)))
                          flatten
                          cleanmap
                          remove-duplicates))

(define new_places (minus objects_places known_places))

; (--- "Places with undefined population: " (sort places_without_pop a-z))
; (--- "Places without coors" places_without_coors)
(--- (format "~a new places: " (length new_places)))
(--- (list->pretty-string (sort new_places a-z) "\n"))
