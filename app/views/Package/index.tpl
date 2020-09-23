<!-- prettier-ignore -->
{extends file='Templates/mainlayout.tpl'}
{include 'Templates/pagination.tpl'}

{block name='content'}
<div class="row mb-3">
  <div class="col-12">
    {include 'Templates/buttons/add.tpl'}
  </div>
</div>

<div class="row">
  <div class="col-12">
    <div class="card rounded-0">
      <div class="card-header bg-gradient-navy rounded-0">
        <h3 class="card-title text-warning">{$subtitle}</h3>
        <div class="card-tools">
          <form
            action="{$smarty.const.BASE_URL}/{$smarty.session.ACTIVE.name}"
            method="post"
          >
            <div class="input-group input-group-sm" style="width: 150px;">
              <input
                type="text"
                id="keyword"
                name="keyword"
                class="form-control float-right"
                value="{$keyword}"
                data-title="Cari Kode Paket"
              />
              <div class="input-group-append">
                <button type="submit" class="btn btn-default">
                  <i class="fas fa-search"></i>
                </button>
              </div>
            </div>
          </form>
        </div>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive p-0">
        <table class="table table-bordered table-sm">
          <thead>
            <tr>
              <th class="align-middle text-right" width="50px">#</th>
              <th class="align-middle text-center" width="*">
                Tahun Anggaran
              </th>
              <th class="align-middle text-center" width="400px">Program</th>
              <th class="align-middle text-center" width="400px">Kegiatan</th>
              <th width="130px">&nbsp;</th>
            </tr>
          </thead>
          <tbody id="result_data"></tbody>
        </table>
      </div>
      <!-- /.card-body -->

      <div class="card-footer clearfix">{block 'pagination'}{/block}</div>
    </div>
    <!-- /.card -->
  </div>
</div>
<!-- prettier-ignore -->
{/block} 

{block 'script'} 
{block 'paginationJS'}{/block}
{literal}
<script>
  $(document).ready(function () {
    search()

    formTooltip('keyword', 'warning', 'top')

    /* Delete Button */
    $(document).on('click', '.btn-delete', function (event) {
      deleteData($(this).data('id'))
    })
  })

  let search = (page = 1) => {
    let params = {}
    params['page'] = page
    params['keyword'] = $('#keyword').val()

    const ROWS_PER_PAGE = '{/literal}{$smarty.const.ROWS_PER_PAGE}{literal}'

    $.post(
      `${MAIN_URL}/search`,
      params,
      (res) => {
        let paging = res.info

        let list = res.list
        let tBody = document.getElementById('result_data')
        tBody.innerHTML = ''
        let tRow = null
        let no = null,
          pkgFiscalYear = null,
          prgName = null,
          actName = null,
          action = null

        for (let index in list) {
          no = document.createElement('td')
          no.classList.add('text-right')
          no.innerHTML =
            Number(ROWS_PER_PAGE) * (Number(paging.currentPage) - 1) +
            Number(index) +
            1

          pkgFiscalYear = document.createElement('td')
          pkgFiscalYear.classList.add('text-center')
          pkgFiscalYear.innerHTML = list[index].pkg_fiscal_year

          prgName = document.createElement('td')
          prgName.innerHTML = list[index].prg_name

          actName = document.createElement('td')
          actName.innerHTML = list[index].act_name

          let editBtn = createEditBtn(list[index].id)
          let deleteBtn = createDeleteBtn(list[index].id)

          action = document.createElement('td')
          action.appendChild(editBtn)
          action.appendChild(deleteBtn)

          tRow = document.createElement('tr')
          tRow.appendChild(no)
          tRow.appendChild(pkgFiscalYear)
          tRow.appendChild(prgName)
          tRow.appendChild(actName)
          tRow.appendChild(action)

          tBody.appendChild(tRow)
        }

        createPagination(page, paging, 'pagination')
      },
      'JSON'
    )
  }
</script>
<!-- prettier-ignore -->
{/literal}
{/block}
