set(src_source
  AnalyticCostFunction.cc
  AutoDiffCostFunction.cc
  PDFs.cc
  Compute.cc
  )

add_library(src OBJECT ${src_source})

option(SHARED "Build shared-libray instead of static-libray" OFF)
if(SHARED)
  add_library(NNAD_INTERFACE SHARED $<TARGET_OBJECTS:src>)
else(SHARED)
  add_library(NNAD_INTERFACE STATIC $<TARGET_OBJECTS:src>)
endif(SHARED)

target_link_libraries(NNAD_INTERFACE ${YAML_LDFLAGS} ${EIGEN3_LDFLAGS} ${CERES_LIBRARIES} ${GLOG_LDFLAGS} ${GFLAGS_LDFLAGS} ${LHAPDF_LIBRARIES} ${GSL_LDFLAGS} ${SQLITE3_LDFLAGS})
