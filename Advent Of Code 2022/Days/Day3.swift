import Parsing

private extension Character {
  var priority: Int {
    guard isLetter else { return 0 }
    if isLowercase {
      return Int(self.utf8.first! - 96)
    } else {
      return Int(self.utf8.first! - 64 + 26)
    }
  }
}

struct Day3: Day {
  let dayOfMonth: Int = 3
  
  func solution1() async throws -> Any {
    let lines = input.split(separator: "\n").lazy.map(Array.init)
    
    var total = 0
    
    for line in lines {
      let halfwayPoint = line.count / 2
      let compartment1 = line[..<halfwayPoint]
      let compartment2 = Set(line[halfwayPoint...])
      
      total += compartment1.first(where: compartment2.contains)?.priority ?? 0
    }
    
    return total
  }
  
  func solution2() async throws -> Any {
    struct Group {
      struct NoBadgeFound: Error {}
      
      var first: Set<Character>
      var second: Set<Character>
      var third: Set<Character>
      
      var badge: Character {
        get throws {
          guard let badge = first.first(where: { second.contains($0) && third.contains($0) })
          else { throw NoBadgeFound() }
          return badge
        }
      }
    }
    var lines = input.split(separator: "\n").map(Set.init)[...]
    
    var groups = [Group]()
    while let first = lines.popFirst(), let second = lines.popFirst(), let third = lines.popFirst() {
      groups.append(Group(first: first, second: second, third: third))
    }
    
    return try groups.lazy
      .map { try $0.badge }
      .map(\.priority)
      .reduce(0, +)
  }
  
  
  let input: String = """
    PcPlnShmrLmBnmcwBhrmcmbHNGFGpwdFFwGNjNbGqNHH
    tzQfRJfWZZztWzVtCTfRzFZjpFjNZjGLHbdHLDdjpb
    CCQTzRLzvQVVfRzJfMPsnBlglgPmBgPmvSrl
    RMfvbbszHTsssFPzDQPggpQJPQ
    NSNcqVtLVGgDlpQBClVB
    hmStGNNLhjNrpWLGSjWrZssbZTMMvTfMnThbRRTs
    fTrTPGTbfftWBBmLjrJL
    DqHwVMqVplDslmlZmpHVwNnShWZFdBBdjWBtWtdtWJSSLS
    MNslpDvVHlwsmpQRgQgCfTTcvcRQ
    pBBhRgDsMsswprBhvgRglZtFGFFRqZtZmRtNqtZPPN
    TdmmzzmdZdqdGFtF
    nmSccCVmSCpDCswMwl
    NptqDsQtDTQzCvlzCpRlRp
    jmZcndmjbZcjrmDvFMFFlwCvzFnF
    jjgLVLrGcdDBNhWQTgHg
    mLVhhfSMSTmMwClHGdpjDHjGdV
    zPrZgJCgbsnrPtZzsCsbpRDjBRHnjGDRldRHppcG
    JJrbsFrZqrgWbbqbrgWzJPNTwhTNCmmvfWCShhhmwwfm
    ftgfljvgfgBTNvtggFDDGLGRDnMDzcQzncGt
    VdbpbVdZwdwrsVVLRrMrDLDBGnBGcM
    wmpWwWsHWBCCCPPvjvmSqlfTTmSNgN
    jSqmzmmSSDRjLMLDwqjNcMMLTTflffWCCsRsTHnHVrfHWTsr
    tdbgZpgBPdgGZGGFTHVpCsCVfVsJpnWl
    FnPQFvbvhFFFbvBwScjhzcqSLLSzSN
    bWdgrWwwFWbgzFWzrmNbdPqttChMSRnmqSPSnqtMRM
    lcPJLDDPPfpMBCRJBtQtMh
    lGDGjTGLLDHPPGjlPTsswsbHNFsNrFNFsrzr
    VmtHfVhBLHVtlhphjZMdnQQZZqZmQDdzQQ
    CPFwPWrvWgrfNgFPCMqZzMDDbznFTqqzDQ
    NNPsfffPCsBLjpVltV
    ssdBBJqJhlTJLsjTJqFFmnmmnnrcmpprmmmPcRlf
    gqtqzSgWQWqmnRPPcNmmQM
    GqbSVtGzvgvgWbZjjBhTdhBsTZBJBZ
    jhNBsPDzLjsVhLSNzgvcvbcwbBWFcgtWCc
    ZQQTTHHnGpMtnpdHpQJfMgrvWWFqbcWWGgrgwCCwwF
    nHpmMnQQMmHpRnHRmMJnnTShPzljzjSNmSDhLsNSPtSh
    GdqnBGFdlqzFnwdSCQZjZLLDZjZRvZLDVvgQ
    PsptsTcftMfcTfhTghVDvvjnRNjVZnvV
    WtPfJTfftJcMTrMnpccFwlCSCGFGCbCwJSbqBl
    GjFLGhjRwFjNSjSdJCBBdQJddbBc
    MVvMMHRzVtHlvlcQBQJHqdpQqCBC
    vDgVztvvmrgrVRrMmsrsmZzZnWhGnNhGWTLfnLwTLhLTjngL
    VljjQJSsrjjrCglsCjsgjVVfDLdZGMdvvGdQMzmvzcDQMc
    HqPBtcpRWwtHbbFwBHZfmfpDfvffDfMfmGvM
    PwHNbcwtqFqnwtNNqPNPPWBTThjhhVTCSJTThssVnSlJJV
    GCccNCrrnCrpnzrnCDPcDDrvHHTBqTPhswqhPTBTTwBhTj
    VfNmRtZgWWHdBdswdjZv
    SmtQfgNmVFgVLVLVmrnMpcDLGCGLGDMpCp
    CrdZdZmPPjrQdRPRDqDLBqBLBSWgWgLDzF
    sQhTNphsVbhhhMJfhNVGqltVSzSllBzStlzFFFWB
    hsMpwQhNMZmPmrwHRj
    cNVpSVRpLHRLsVWWfnfsCshW
    jvqjTgqZPlJZmbPPfbpswsPb
    vlqdTZdtJvqdZjgqZrtRpQFtLFRQczHGzt
    JJQndVQnQgTfNvGf
    ljpbWbmNbDlGTvggGvZf
    mpmRbMmmNDFDmScpzCsdzrnJrsCzrrnM
    tNFtNFFzzjjzjBtVNZVbjZGlpSvTllpWwvnBlWGGBGCC
    fPdcrrgPHrHMMMWlppGJSPwGSnGv
    fmrqrhhfhdRddHrhQqQrfnLZjLtNttZjjRtzjFtRNj
    sphRcpQRhfmnmfpptg
    WVPlGLlSjCjSlGSHJJWZdmbmfvPmmnftbbgDdt
    LJjjqVNjlnCTRcRhhsNcFF
    vwwqttFjwgClRNCCvGNmZZMmJsPJjJpTdMpsZd
    fBLVHHHrFnhHhnrVSTmfdPdPccTTPsMfsJ
    QzVWzznzFbWNGNlt
    vjMddVVmnWpdMndjvhhWfNLpfBsfLLZLBBSqqTZq
    RFlrzQJPSRGzzzzgBZNsgBZTBflfgf
    cQFDRHFDDGCJShCnvwVnnhCn
    hgjlpRRLlPJJhTLJMDnwBndSPBNvMqnN
    FGWVfZsmCbmVzrvtwCSMtMdnDMCw
    VsVmVZfVQDmVFrrmzmGrHHTJgJjhHJcllglLQJRL
    rrTVcTBgsjTffmfWHZTv
    JLdnDlpGlGSLlpwJpHZfFvRZnWzWrHWqFH
    wQDpDrdSlSCblCdwdSLlwQGBthPMsghNsVNVtCNNhNPjhs
    CtCMvNhDMHfDDdffqtDtCflpJlBpvmWWJWwlpwFFvjwB
    rGSbVGZrSsFJjlmBFZWp
    rbbQgzVGrFVSPPGqfhftfqztNtqHtt
    lMGZCGphllZDNshNNmHHND
    PLwjVwJVsHmRrZZw
    ffSdzjfZSjtjSjLtLLFFFGqFzznCpCnCBblQ
    CqRnlzHCRWTlHPTZVQrcQtFsQFTcrQ
    DfJcdBDBcftQjsrsBtjZ
    JDfdGhSvNGhNfffGSfRznPvcRWcqCqmlvlcn
    JPhBBBQCnCJCMhnhMZRrRZgbDgrWrNbglDgR
    jLtSTwtsShwRNpRWrh
    FLLSHsjGLGczvfPfJdfhddnHPC
    BjHBNrWmTjFgJngbJhWd
    vsGttMDtwCMQCJnqqqFJsggqdg
    GFtDSwwMpTrzSSfcfm
    rnWDQvpwWpDDcPjFPPHZjVDZ
    CTJCRmCJcZZZHCCQ
    LdlmdQJNpnLWbrfL
    VdTdcVTZwCRGVGGMVmttlF
    gnrsbngfgQSpBfpMBBBpSgMNNJbmGmlqGDqDNlFFJlGNFz
    gprgQhgpMMMPsrRTCdPZwCwZZCRH
    cHlCVGbbWHWqRNThhcNcmh
    MwQDzpwdJwpBpPDQvrhShfLTTRLfLdjfNRqS
    JwMBBrPsPDwQMDPPBPQJwMrvWHFbHHlgbsGnnWHnFnRGlblF
    PQPjPDjRRQSFLSlgSmLlfh
    zpLdBddbNCdqGbWJGWpJWWlsFsmmFpwfflFgfHwFhgmh
    nJLdLVnzqqbjRctcPDQVTP
    JdztScztPdSWLJLtgMbCjhvlbPRbjbMvCh
    VZrqfQcFQwGVVFqfrTFTNqhljRHDMvMMGhRDRRHGbDhG
    NZQNVQQpQmrZFQQFwQQVVZgBszJJgznstnmtcztdBSgs
    nFHLNJzFbLJGGLMlTTRZbZRhWRTr
    wVmgBBmtmwlqlWTwTM
    sdvmgcPsCPPQQSMz
    SccCqmQmgBmppLQmpSMjjlJzzsNPMDRbPNPlJM
    VHZvwtZwhZHtdTwrVbNsljlRDlJPDhzsbN
    dZwftVRftmcgpBCmBf
    NTTlVlgNSflqbphFFhNbFp
    wmmLmjwzwbWGLjRmtZZdhZLFtQQLQBFh
    RvjbMjjvMzMWbDWwvzPjvmWSfVfsTlVVPVgTgPfVsnnnsJ
    BsBsZHZNdWwsNdrzgCrMMqsjzzMC
    flfhVWFmLrhQzCCh
    fVbmFSpnSSmtnPZvdWbwvdvdHZ
    NsZWWWWLsBZPhfsLmPhcFCCHCMMrqfqcvHMfHH
    nThSllnplGlMpvFRcCqrrr
    DnTwSztgzlDnVGTwztmdZhmLdJdNDshBdsWs
    RBBGTFZGglMHvrtcgSdnNgjg
    DmVcbmbJmwJDJzVVwzJfmfstnztvjnNjvNSpdptvzCnpjj
    DsLcfLmbhVQssQJQscWRPBZZMMRLHFHZBGMG
    FVvhVnhFnFhmvFhVcMBHLgcPClrqqrtqCppldrRRTppldg
    QLWfDNwsQLtlrrCtDdpq
    sJwZwLsGJWGGwzzWZNbWNLjQHSVhvHSnhcMFcbVmnvcchSBS
    jTMNMrHBJWWDffRqfDBqfD
    QmSFphtQqQmVmqVnPnPlpwgfnRnDPl
    VqFmLFbLhmZhGFGmCmGtZLtJWzWHcJrNrHMccjMscMHzMZ
    hGPGmbfPzbPfgdMdWGqBGQcqpp
    nvFTvDrTdNZZlrjnMHHHpBBcppqq
    rNlZZNLvRdRCRFFwZwhgbmSJPSmPfhfwhS
    vjdbFWTtFRRvtvZZvdWJWbGjLhCcnrrrNqLNCPqchShNqc
    QHQVlDsMfmmDMHDBdLdCSLnhNLNNfqCd
    VQHsMDpHlzMBBwlsmMzmmlVwptvTWdvJdbvJtRTWgGFJJGtR
    nSScBcnbbFSQVdBFBtWpwtvtPbTZthtTvT
    pRzHpGjCDGzHGCGsThqqwZwPhCtvhTqZ
    NzlzjDDpNldBFrlfFQ
    qJlDlPPWppgppqPlplpfdvgnbMfGbdgCghMdCM
    QWTWZcSsWbvVvTnhfC
    tRFLwZrcrWzzlJmtBqlm
    HMNMvvzzNcmfNmfbhs
    qVcwCgjCLtWRSLsTPbmPfmTh
    RtWCJgddWRtCJdWWgdBjwWWwpzMFpHGprcBGFFnGHQZHQGpF
    gZgBDgDVGDGjmDZRtgjvVvtQdnLrcRcrdfdfCcnlscsJsn
    WTqzqHqNzpHpwzNhMHNwWPbQCQcCLsnCrLLfcrffNflcNn
    zHTwwpTPzTTwlFTFzwqzPbwZGgGZZBtmGGvGmBGZVFStFZ
    znlSSzfzTcmmfcCt
    PHWWGpqgPShPMwGwqJFTVtwtCVTCmTJcFc
    qHqqSggLrRLBbvDDdndzRQ
    WBddBQWZWWQqqQFMWfmrWsJnmVJJNDDVJGsLmHmLDN
    PTgCjvCCPPPzSZGJVLsVZCHHnH
    pzwtPTvzTjRTPtwSjPSzRgBbWMBfMwwZfbWrMrZFqFFM
    BqDwVqdqlDlblQMf
    ZcCWWcWzvJZjcPjZZZfTHfQJQHThqpMbQQJf
    LPCcZcczZLgCjvPWgvstjsjmRRBdmGrdGdmSFGnFrtGmqr
    CBvgQssVzfCBQSgvvvfmrlGrCtMGwthJlJtbrh
    TpLqLRFpqdRpRTfNPtRmrMMtMlMMmlMJlt
    PZTjqFFTHZZNZpqcVWzVvgzcWnSWfBDD
    SVSTpgpVpdNbpcVdfjcNfbcJnqsltcJPvRJqRwQqlQsJls
    zhWzDLmFHhmrWZmmzHJJQlnswqsvttrstQqs
    zGtZFGGCmZmGGFhLBWBGGFdgVjgppMTSTgMfCNfVVSdj
    CzjNJGcnzQJltPHttcPHTP
    bLVsqLbLmSSVrqmdhVSmsVFFprfrFWrwTTWWWZpFPtlP
    ssDsMqLqhvmvhdmdvzRCnQgRzzBjgnlNCM
    TzTLzzSGRlRSjWzlWRzHGTpNhPhJPmdnNPPbhlbPbdhfPh
    mBCDBVrCqVQvQMBcVcqBrBDsbtJfnZNbJndNNhthZNJfPZPs
    wMCrqVvBzmzHTGLw
    NbfwfZPPdVNPdBdQBcmQzrQz
    nnWqHLWGFMDFDLDjsqnHLsrQGzmJczmQrgJmJGZmQrgJ
    FFWRsHMHCZCWFwRwphpvlfTTpp
    PclPlVZvLDNvVZSLSMvvDttmtfzFtzHqtqtzzccCFc
    jrggQGhjQsTDbrbJjJQqzzCsdtzzFCdHqmBBHz
    WGDgngwrQggZMNvMWPMRRV
    wNgpMdMMcdSscccNcLLTbtQJtQJQltJwFtlBlzBt
    HHGhrLrCvHWHCPhrWDtnBllnQbfQftGnfnBF
    HvLjWCLHPZvHHHZjjrqVTTZVcppMgNNNNSpS
    QQrwQmvWQjgTfvBjfffrSDcrqSqDDVLctqqcVd
    GnHFnGhGplGMlHMNhzBzlLPLVcVNCPDqVNdcqLdqtV
    GnMGpslMhGsRzzHzGsZFZQJTTmWfBbvfgfgJRfbwbW
    MRCtSwMhvjCGtvMZDVWpVZJlVccNDlpb
    gdLQFFwwLfHJWnQlcJJbWc
    rdqdmqHLTLmsswsFHLFtMPRMCSSRtSjTPMPSCR
    jmCCnLCLZjZjRjQTLZQhGPGhhzHhDRGRDzwzwh
    stlJlrlJJcSSfSMMzPfhhGhzpwhpNwhD
    rbrbBcSlWmdZWjDnTm
    PNBRNnnqQRNfVfRtVVzgFLLttpSwgzzzmFFF
    fcWlcbvvCFzLbwLw
    rlrMrhTJhDcTTfhRNqHRQPQRQNQB
    TrprpprRVVfpRpVqTVpzDdvmvbbCchhcttqcthSMdd
    JlnZnFlsMBZnJHlsLsCLbSNtbNhdbbShCScm
    FlZjjsHHsnQFQwTDzMRRpGRR
    wHWzwCTTqJhzzvJhWHWhqJWrFsFQrrrFCfFfgjjgjprfsp
    DBRmZRtZLbnRBGSBmtGSLpjBrrsfrgsTQVrVrrPrgr
    DLnbcbtLtmNNmbRcGbcGmHzlThNNhqJTHdvqvWlHJh
    GSNqjRcqflNLnCTTWrWn
    BmwQtmtJwPwmzMwQtHtVssvrnpWTTnsTTgpVCLCs
    DBBQHJJrzhzQDDfSljRfhccfcdZf
    wtgtChCwzqgLzjggqtHtjFHHFcnPfdRDfZZVcPfVZZfGnfdm
    vBTrRTTWGGmcTDVD
    SJMbbpWslJblSSNzNsztRChzqRCj
    gBHHCtVCSHMQlfFTQqCfmq
    WrpdwjbwbwQGlPqSqblP
    wWDncWrDDNdWNRjScScjpzvHZtBMZtJsvLVgvzssBsvs
    VppWpVfmZPBlnmrGBzhttMzMpctLLcChSh
    FwgLJvRdHcwMzSzjzc
    QvbgdQLQgDvsqvqRHRDdDQDBWmBGBflnVbZmZmmnBBWrmW
    SqShwLFCQGpDHCtZCWpW
    bdHPHjTbJdsMnPHPbdjgtnBlVlBnVgtZpDBpWV
    bdmPcjbjMNMvvHbTcQRNfRwRwLffwwqwNF
    zdRHTpQTQHQnpnnQRHTsNNlJSJWmzJmJllNmSG
    FBbRvLbFRwLqbbVgBVqqLFqJtJNcltsSGmgmGtNtgWmstm
    FLhhfvvVwvjqfLRBqLVqbwqZQrTTpHMHjdrpnnDPDQCdCrpC
    JgjzvbJCWgbjgGbJWjRhgNPGHHBMtqBStZZsHMSsBqtD
    cfQdwQFdQQppnVVnlFLLBsBZMhqPlPMMqBSHDtHM
    wnQhcnVddmdWgjvjmvRjjJ
    QpcRtndvsLcVJtRSzWSlWjzSbjjWBv
    qGZPqCTmGPqgGTCqHgCqZCPFWbbBNBMNBbdBMlWWrbjlMbFl
    qhHDGhCmPhZHgDmDVQthttRchLwLdwcc
    srpPMwlMmsrGFGswvDRhRWRDJJJchJ
    fSgBbCBNnBTTgCNLTCRJhRJVWhTcVVVFFJdR
    SbBnnLNZCLFQCZjnCnZFjPrzqmlMmmsrpzrlsmtt
    BBsfDfsBDSWRwlLqmWCpWcllrl
    nQMgMnnnhdntgMBrCdpNNLNlNqLqLl
    FnQFHzPQJjJGRBGvfR
    lRnVRFFlgMCRVwLgFZRnZQHWdcftHdmcJHmmMdzzfz
    DGBqGQbhhBDbSBpGDBzqdNHJdtmcWdqdmtcm
    bjbsBvjhSlVsPRgLQl
    dDLbRdTMRJMbFRzZBfzNSjtNBzBD
    PmgspqqVrppTVrvrsPhhfQwZBwNjNtNffzqqfwwN
    mCcmsngrPvpVTssCVsvsPLRRJllGFlnRGbMJMWWlJJ
    fGlGZHRRbwgPbZRRNCdcSWpncnQtQWlWcWpW
    JrTLJgVvVLQQvtSvQncQ
    JrrrmMTBVTmjBMrVjrshmJzgCfzRPCRZPGHfbwNPzbZHNH
    qqqlDDZzVVnNqHDDFFFNlQpzjrTvsvzTbgJQQggjJp
    cWPWcCmMfCMWdtPMhMbQQQjGGjpdvjTbjgjr
    WtMSBCtCwchChMfBWtcPnNVNqZZLDRNqTRnnlwHn
    mvQQnhBvhmvBmncmZBclTZTQccRFNFFdqFFgVqSRrgFrppNR
    MjzJPzGPfffMCjVVjfPHLCFRNFStqrdRSdqdNGRqNptq
    HDJHPjDJLfjbzfwPjCzCWWTwlmQhBnsWBvVsvBvZ
    RVjcshhscQhrVjhvzjVfDNnzGtftmDHFttFGGf
    qLcBCCMBJJbTdBDnNtdfnmDG
    WpZgLLclTclRwgjgsrwsvj
    shhhltNPcDtlNcNMcsctNtppLZvWWFLTFFZpTZDQgFLT
    dRgJVzRHbqnLpTWQvLLJfp
    mCVCdzqHndbqHCrVqRrmbwtNBsmPwNmScPgtPhBclw
    bDDZMDrFPsrsMcsrbJZJdMMGpSzpSbwRSSRGpCHCGzlhCC
    BWWNQjBLQVHhlGpSCmwj
    ffwnNwfgtnNgVVwfNWBWnFsMJTJTcPFJcTFDsrJstJ
    vQbQLQBpBvbvpHplHNTHWGZDngntZCQGgZhGhtjG
    rqccPPmcrffRmsmCjVgnrGChChDjgW
    fqRJsJMSlSzSWTbT
    brsjjJPJwrJJsrRRlllNQGWQpwppCtfGGtWzGGMQ
    ncBqqLTDnmLgVDZVnBDmdtVVtMzWWdMCQdpQWdVz
    hDZgTSSnTzNPNFSFPF
    VZVJJtWTsfTVVWsJhPWrCjzSBJlHSmjJCRlNSSlz
    CqMpwccgvvgLnvLbMMRRjBNHzjmGmwNHlmlN
    gLqqvpCDfVDrTfVW
    CNMDGNPPNJCGbLnTffsTLT
    tcBBRlrBdQrtmtWFjjbnrTjjFbjr
    cTQQhcmvcBRcwDMVDZZPPCJh
    mBCdgPLgZmLfGmfvGhtRQJWjtjQGQhtN
    pMwrVwbwHMsqcTWQhQWzggTTWp
    nnSMwrlrsmSZgvvmDd
    WNSzpCzNzqzNdmqrRHrrLHFrJH
    MtPfvnGMPnMcbnRtDHTRFFDrmJRQ
    PcBsfPPHPGGfcSzZjNjpNZZdCs
    mDCZVLDhWVSDCRvGtsGgGRHl
    JjPwPNdcPnjPdcwNltHzzGmgGJzQJJRQ
    dqfjnNmwmbmWrZMbMrThhB
    qtBpNZFpBGFNfZNPmZPmQmHrmPPPTz
    LLwJLvDvlWWLHdwDrVcCRcDVzzVVcV
    sMMwvgjnMvjvnlsvNFBqfGHFqHGjtSpS
    MmZZsFgwJTdTMdgmZdZRgFhDHhPQPPnRPhCrHhnnrPDD
    fBcLlNNpQCDLDJJC
    jSbWWlWpBpclWlWpNWlVBbWVdgwswFJmFJsGtdMggZFGbZwd
    CMVQVMLLMFGRCMWQttnqqwQwhqsm
    pJzlczSpPpPgmsqNhmPGDstq
    gZgTccZGGpzdpjclGRVMVRFRMFvHRLRdLf
    FMWMSBtStZqZWQtFtScWWSZmHPVJJVHwwlTgmgbzQwbwTJ
    jhGLhdjNjsLvLsshzHJPVdVmmbzHzdHJ
    jvDRNjnDNGRCzjLzZZpqnrFBSccWrMcB
    zggmthDDghHvtrdgrVWfSBRwTHLWHwsBWw
    PGGjpCjQnJQGJcJnnQpjFWVSsZWVLRZLBcsWSZBRWS
    FGQlpnJCbqqGGRCjjnlCqGMtdNmmmvdNmmmzvhbrmgMz
    TstvBTdgBhqTsdTcPlfCSrNMrNnrCNNSNNgp
    HwLQwQDZzDjnDbmMhNSnmm
    FZLVzLLQHRRzwWHjdPlJctlJtlsllhRs
    fBtPsMDDswHvBmmVdBlSBRcGGnhVhg
    LWJbrpFqpTLTTjqqNWlhnRGGSnhrcSdlRlsh
    JWNbbpjJzTbNNNJNJMvmvfZHvzDsHDCsZw
    LPGnPNLtwGhFFnJPfsqpVVszzpsP
    TcWdvlrcWddggrDBDDdDMmWzRJqfVQZqmsfZsRQzZfZzQJ
    TldWrMrDdlDCDdMTcwSLVCSShLNSwHjhGF
    JGsWWWQsJmPwQWbBPmccbcbqFfMMpFDVCDFVFVCDqqfFwD
    ZtLnlvLnNtvLndnCmfMVSmVCClfpVp
    zTzZtjnZNLNmZvdtznntHHZJbBRGBRQWcJGbGsbsJRPQWT
    MLmlMTPtQtMNlhbqbbqhflBB
    rcrvjpSvScbRbBvbDBPG
    ZZJzSHpzPrJzHFmMVMFmHCLNtV
    """
}
