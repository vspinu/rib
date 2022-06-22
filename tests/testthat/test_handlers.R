

msg1 <-
  structure(list(id = "18",
                 ts = structure(1655660284.97274, class = c("POSIXct", "POSIXt"), tzone = "UTC"),
                 ix = 1L,
                 event = "historicalData",
                 val = list(event = "historicalData",
                            reqId = 1655660265L,
                            bar = list(time = "1655414100",
                                       high = 1.0549,
                                       low = 1.0546,
                                       open = 1.0546,
                                       close = 1.0549,
                                       wap = NA_real_,
                                       volume = NA_real_,
                                       count = NA_integer_))),
            class = c("inmsg", "strlist"))


msg2 <-
  structure(list(id = "1482",
                 ts = structure(1655662609.35882, class = c("POSIXct", "POSIXt"), tzone = "UTC"),
                 ix = 1426L,
                 event = "historicalDataEnd",
                 val = list(event = "historicalDataEnd",
                            reqId = 1655660265L,
                            startDateStr = "20220618  20:18:29",
                            endDateStr = "20220619  20:18:29")),
            class = c("inmsg", "strlist"))


hlr <- bld_save_history()
hlr(tws, msg1)
hlr(tws, msg2)

hlr <- bld_save_history(contract_fields = c(symbol = "localSymbol"),
                        req_fields = c(wts = "whatToShow", bar = "barSize"))
hlr(tws, msg1)
hlr(tws, msg2)

hlr <- bld_save_history(contract_fields = c(symbol = "localSymbol"),
                        req_fields = c(wts = "whatToShow", bar = "barSize"),
                        partition = "fields")
hlr(tws, msg1)
hlr(tws, msg2)

hlr <- bld_save_history(contract_fields = c(symbol = "localSymbol"),
                        req_fields = c(wts = "whatToShow", bar = "barSize"),
                        partition = "parquet")
hlr(tws, msg1)
hlr(tws, msg2)
