add_library(definitional rec_on.cpp induction_on.cpp cases_on.cpp
  no_confusion.cpp projection.cpp brec_on.cpp equations.cpp
  init_module.cpp)

target_link_libraries(definitional ${LEAN_LIBS})
