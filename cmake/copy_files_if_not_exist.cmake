# cmake/copy_files_if_not_exist.cmake

# 스크립트에 필요한 변수가 CMake 명령줄(-D 옵션)을 통해 전달되었는지 확인
if(NOT DEFINED SOURCE_FILES_LIST_STR)
  message(FATAL_ERROR "SOURCE_FILES_LIST_STR variable is not defined for copy script.")
endif()
if(NOT DEFINED DESTINATION_DIR)
  message(FATAL_ERROR "DESTINATION_DIR variable is not defined for copy script.")
endif()

# 전달받은 세미콜론으로 구분된 문자열을 CMake 리스트로 변환
# (CMake는 종종 자동으로 처리해주지만 명시적으로 하는 것이 안전할 수 있음)
# string(REPLACE ";" "\\;" SOURCE_FILES_ESCAPED "${SOURCE_FILES_LIST_STR}") # 필요시 사용

message(STATUS "Checking files to copy to ${DESTINATION_DIR}")

# 원본 파일 리스트를 순회
foreach(SOURCE_FILE ${SOURCE_FILES_LIST_STR}) # CMake가 세미콜론 구분 문자열을 리스트로 처리
  # 원본 파일 경로에서 파일 이름만 추출
  get_filename_component(FILENAME "${SOURCE_FILE}" NAME)
  # 대상 파일의 전체 경로 생성
  set(DESTINATION_FILE "${DESTINATION_DIR}/${FILENAME}")

  # 대상 파일이 존재하지 *않는* 경우에만 복사 수행
  if(NOT EXISTS "${DESTINATION_FILE}")
    message(STATUS "Copying missing file: ${FILENAME} to ${DESTINATION_DIR}")
    # CMake의 내장 파일 복사 명령 사용
    file(COPY "${SOURCE_FILE}" DESTINATION "${DESTINATION_DIR}")
    # 또는 execute_process 사용 가능:
    # execute_process(COMMAND ${CMAKE_COMMAND} -E copy "${SOURCE_FILE}" "${DESTINATION_FILE}")
  else()
    # 파일이 이미 존재하면 메시지 출력 (선택 사항)
    # message(STATUS "Skipping copy, file already exists: ${FILENAME}")
    continue() # 다음 파일로 넘어감
  endif()
endforeach()

message(STATUS "File existence check and copy finished for ${DESTINATION_DIR}")