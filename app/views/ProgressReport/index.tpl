<!-- prettier-ignore -->
{extends file='Templates/mainlayout.tpl'}

{block 'content'}
<div class="card rounded-0">
  <div class="card-header bg-gradient-navy rounded-0">
    <h3 class="card-title text-warning">{$subtitle}</h3>
  </div>
  <!-- /.card-header -->
  <div class="card-body">
    <!-- form start -->
    <form id="my_form" role="form" method="POST">
      <div class="form-group row">
        <label for="pkg_fiscal_year" class="col-lg-3 col-sm-4 col-form-label">
          Tahun Anggaran
          <sup class="fas fa-asterisk text-red"></sup>
          <span class="float-sm-right d-sm-inline d-none">:</span>
        </label>
        <div class="col-lg-1 col-sm-2 col-3">
          <input
            type="text"
            class="form-control rounded-0 text-center"
            id="pkg_fiscal_year"
            name="pkg_fiscal_year"
            value="{$smarty.session.FISCAL_YEAR}"
            autocomplete="off"
            data-toggle="datetimepicker"
            data-target="#pkg_fiscal_year"
          />
          <div class="invalid-feedback"></div>
        </div>
      </div>

      <div class="form-group row">
        <label for="prg_code" class="col-lg-3 col-sm-4 col-form-label">
          Program
          <sup class="fas fa-asterisk text-red"></sup>
          <span class="float-sm-right d-sm-inline d-none">:</span>
        </label>
        <div class="col-lg-2 col-sm-3 col-8">
          <select class="custom-select rounded-0" name="prg_code" id="prg_code">
            <option value="">-- Pilih --</option>
            {section inner $program}
            <option
              value="{$program[inner].prg_code}"
              data-value="{$program[inner].prg_name}"
            >
              {$program[inner].prg_code}
            </option>
            {/section}
          </select>
          <div class="invalid-feedback"></div>
        </div>
      </div>

      <div class="form-group row">
        <label for="act_code" class="col-lg-3 col-sm-4 col-form-label">
          Kegiatan
          <sup class="fas fa-asterisk text-red"></sup>
          <span class="float-sm-right d-sm-inline d-none">:</span>
        </label>
        <div class="col-lg-2 col-sm-3 col-8">
          <select class="custom-select rounded-0" name="act_code" id="act_code">
            <option value="">-- Pilih --</option>
            {section inner $activity}
            <option
              value="{$activity[inner].act_code}"
              data-value="{$activity[inner].act_name}"
            >
              {$activity[inner].act_code}
            </option>
            {/section}
          </select>
          <div class="invalid-feedback"></div>
        </div>
      </div>
    </form>
  </div>
  <!-- /.card-body -->

  <div class="card-footer">
    <!-- prettier-ignore -->
    {include 'Templates/buttons/search.tpl'}
  </div>
</div>

<div class="card rounded-0 sr-only result-container">
  <div class="card-body"></div>
</div>
<!-- prettier-ignore -->
{/block}

{block 'script'}
{literal}
<script>
  $('#pkg_fiscal_year').datetimepicker({
    viewMode: 'years',
    format: 'YYYY',
  })

  $('#btn_search').click(() => {
    search()
  })

  let search = () => {
    const data = $('#my_form').serializeArray()

    let params = {}
    $.map(data, function (n, i) {
      params[n['name']] = n['value']
    })

    $('.result-container').removeClass('sr-only')

    let resultWrapper = document.querySelector('.result-container .card-body')
    resultWrapper.innerHTML = ''
    $.post(
      `${MAIN_URL}/search`,
      params,
      (res) => {
        if (res.length > 0) {
          let title1 = null,
            title2 = null,
            title3 = null

          title1 = createElement({
            element: 'h5',
            class: ['text-center'],
            children: ['LAPORAN PERKEMBANGAN CAPAIAN KINERJA'],
          })

          title2 = createElement({
            element: 'h5',
            class: ['text-center'],
            children: ['BINA MARGA KAB. SEMARANG'],
          })

          title3 = createElement({
            element: 'h5',
            class: ['text-center', 'mb-3'],
            children: [`THN ANGGARAN: ${params.pkg_fiscal_year}`],
          })

          resultWrapper.append(title1, title2, title3)

          for (index in res) {
            //#region Program
            let progLabel = createElement({
              element: 'div',
              class: ['col-lg-2', 'col-md-3', 'col-sm-4', 'col-6'],
              children: [/*html*/ `Program <span class="float-right">:</span>`],
            })

            let progValue = createElement({
              element: 'div',
              class: ['col-lg-10', 'col-md-9', 'col-sm-8', 'col-6'],
              children: [res[index].prg_code],
            })

            let progContainer = createElement({
              element: 'div',
              class: ['row'],
              children: [progLabel, progValue],
            })
            //#endregion

            //#region Activity
            let actLabel = createElement({
              element: 'div',
              class: ['col-lg-2', 'col-md-3', 'col-sm-4', 'col-6'],
              children: [
                /*html*/ `Kegiatan <span class="float-right">:</span>`,
              ],
            })

            let actValue = createElement({
              element: 'div',
              class: ['col-lg-10', 'col-md-9', 'col-sm-8', 'col-6'],
              children: [res[index].act_code],
            })

            let actContainer = createElement({
              element: 'div',
              class: ['row', 'mb-2'],
              children: [actLabel, actValue],
            })
            //#endregion

            //#region Package
            //#region Table
            //#region Thead
            //#region Thead Row 1
            let headNo = createElement({
              element: 'th',
              class: ['text-center', 'align-middle'],
              attribute: {
                rowspan: 2,
                width: '50px',
              },
              children: ['No.'],
            })

            let headPackage = createElement({
              element: 'th',
              class: ['text-center', 'align-middle'],
              attribute: {
                rowspan: 2,
                width: '*',
              },
              children: ['Paket Kegiatan'],
            })

            let headContractValue = createElement({
              element: 'th',
              class: ['text-center', 'align-middle'],
              attribute: {
                rowspan: 2,
                width: '15%',
              },
              children: ['Nilai Contract'],
            })

            let headWeek = createElement({
              element: 'th',
              class: ['text-center', 'align-middle'],
              attribute: {
                rowspan: 2,
                width: '10%',
              },
              children: ['Minggu Ke'],
            })

            let headTarget = createElement({
              element: 'th',
              class: ['text-center', 'align-middle'],
              attribute: {
                colspan: 2,
                width: '200px',
              },
              children: ['Target'],
            })

            let headProgress = createElement({
              element: 'th',
              class: ['text-center', 'align-middle'],
              attribute: {
                colspan: 2,
                width: '200px',
              },
              children: ['Realisasi'],
            })

            let theadRow1 = createElement({
              element: 'tr',
              children: [
                headNo,
                headPackage,
                headContractValue,
                headWeek,
                headTarget,
                headProgress,
              ],
            })
            //#endregion

            //#region Thead Row 2
            let headTrgPhysical = createElement({
              element: 'th',
              class: ['text-center', 'align-middle'],
              attribute: {
                width: '75px',
              },
              children: ['Fisik (%)'],
            })

            let headTrgFinance = createElement({
              element: 'th',
              class: ['text-center', 'align-middle'],
              attribute: {
                width: '125px',
              },
              children: ['Keuangan (%)'],
            })

            let headProgPhysical = createElement({
              element: 'th',
              class: ['text-center', 'align-middle'],
              attribute: {
                width: '75px',
              },
              children: ['Fisik (%)'],
            })

            let headProgFinance = createElement({
              element: 'th',
              class: ['text-center', 'align-middle'],
              attribute: {
                width: '125px',
              },
              children: ['Keuangan (%)'],
            })

            let theadRow2 = createElement({
              element: 'tr',
              children: [
                headTrgPhysical,
                headTrgFinance,
                headProgPhysical,
                headProgFinance,
              ],
            })
            //#endregion

            let thead = createElement({
              element: 'thead',
              children: [theadRow1, theadRow2],
            })
            //#endregion

            //#region Table
            let tbody = createElement({
              element: 'tbody',
            })

            let n = 1
            for (idx in res[index].detail) {
              n = res[index].detail[idx].pkgd_no != '' ? n : n - 1
              let bodyNo = createElement({
                element: 'td',
                class: ['text-right'],
                children: [res[index].detail[idx].pkgd_no != '' ? n : `&nbsp;`],
              })
              n++

              let bodyPackage = createElement({
                element: 'td',
                children: [
                  res[index].detail[idx].pkgd_no != ''
                    ? `${res[index].detail[idx].pkgd_no} - ${res[index].detail[idx].pkgd_name}`
                    : '',
                ],
              })

              let bodyContractValue = createElement({
                element: 'td',
                class: ['text-right'],
                children: [`${res[index].detail[idx].pkgd_contract_value}`],
              })

              let bodyWeek = createElement({
                element: 'td',
                class: ['text-center'],
                children: [`${res[index].detail[idx].trg_week}`],
              })

              let bodyTrgPhysical = createElement({
                element: 'td',
                class: ['text-right'],
                children: [`${res[index].detail[idx].trg_physical}`],
              })

              let bodyTrgFinance = createElement({
                element: 'td',
                class: ['text-right'],
                children: [`${res[index].detail[idx].trg_finance}`],
              })

              let bodyProgPhysical = createElement({
                element: 'td',
                class: ['text-right'],
                children: [`${res[index].detail[idx].prog_physical}`],
              })

              let bodyProgFinance = createElement({
                element: 'td',
                class: ['text-right'],
                children: [`${res[index].detail[idx].prog_finance}`],
              })

              let bodyRow = createElement({
                element: 'tr',
                children: [
                  bodyNo,
                  bodyPackage,
                  bodyContractValue,
                  bodyWeek,
                  bodyTrgPhysical,
                  bodyTrgFinance,
                  bodyProgPhysical,
                  bodyProgFinance,
                ],
              })

              tbody.appendChild(bodyRow)
            }
            //#endregion

            let table = createElement({
              element: 'table',
              class: ['table', 'table-bordered', 'table-sm'],
              attribute: {
                width: '100%',
              },
              children: [thead, tbody],
            })
            //#endregion

            let packageWrapper = createElement({
              element: 'div',
              class: ['col-12', 'table-responsive'],
              children: [table],
            })

            let package = createElement({
              element: 'div',
              class: ['row', 'mb-3'],
              children: [packageWrapper],
            })
            //#endregion
            resultWrapper.append(progContainer, actContainer, package)
          }
        } else {
          resultWrapper.innerHTML = /*html*/ `<h3 class="text-center">Data tidak ditemukan.</h3>`
        }
      },
      'JSON'
    )
  }
</script>
<!-- prettier-ignore -->
{/literal}
{/block}
