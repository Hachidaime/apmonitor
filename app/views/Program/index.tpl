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
          <div class="input-group input-group-sm" style="width: 150px;">
            <input
              type="text"
              id="keyword"
              name="keyword"
              class="form-control float-right"
              value="{$keyword}"
              data-title="Cari Kode Program"
            />
            <div class="input-group-append">
              <button type="button" class="btn btn-default" id="searchBtn">
                <i class="fas fa-search"></i>
              </button>
            </div>
          </div>
        </div>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive p-0">
        <table
          class="table table-bordered table-sm text-nowrap"
          style="min-width: 576px;"
        >
          <thead>
            <tr>
              <th
                class="text-right"
                width="40px"
                style="
                  /* Background color */
                  background-color: #ffffff;

                  /* Outline */
                  outline: 1px solid #e9ecef;

                  /* Stick to the left */
                  left: 0px;
                  position: sticky;

                  /* Displayed on top of other rows when scrolling */
                  z-index: 10;

                  /* Box Shadow */
                  /* box-shadow: 0 0 2px -1px rgba(0, 0, 0, 0.4); */
                "
              >
                #
              </th>
              <th
                class="text-center"
                width="120px"
                style="
                  /* Background color */
                  background-color: #ffffff;

                  /* Outline */
                  outline: 1px solid #e9ecef;

                  /* Stick to the left */
                  left: 40px;
                  position: sticky;

                  /* Displayed on top of other rows when scrolling */
                  z-index: 10;

                  /* Box Shadow */
                  /* box-shadow: 0 0 2px -1px rgba(0, 0, 0, 0.4); */
                "
              >
                Kode Program
              </th>
              <th class="text-center" width="*">Nama Program</th>
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

    $('#searchBtn').click(() => {
      search()
    })

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
      `${main_url}/search`,
      params,
      (res) => {
        let paging = res.info

        let list = res.list
        let tBody = document.getElementById('result_data')
        tBody.innerHTML = ''
        let tRow = null
        let no = null,
          prgCode = null,
          prgName = null,
          action = null

        for (let index in list) {
          no = document.createElement('td')
          no.classList.add('text-right')
          Object.assign(no.style, {
            backgroundColor: '#ffffff',
            left: '0',
            position: 'sticky',
            zIndex: '10',
            outline: '1px solid #e9ecef',
          })
          no.innerHTML =
            Number(ROWS_PER_PAGE) * (Number(paging.currentPage) - 1) +
            Number(index) +
            1

          prgCode = document.createElement('td')
          Object.assign(prgCode.style, {
            backgroundColor: '#ffffff',
            left: '40px',
            position: 'sticky',
            zIndex: '10',
            outline: '1px solid #e9ecef',
          })
          prgCode.innerHTML = list[index].prg_code

          prgName = document.createElement('td')
          prgName.innerHTML = list[index].prg_name

          let editBtn = createEditBtn(list[index].id)
          let deleteBtn = createDeleteBtn(list[index].id)

          action = document.createElement('td')
          action.appendChild(editBtn)
          action.appendChild(deleteBtn)

          tRow = document.createElement('tr')
          tRow.appendChild(no)
          tRow.appendChild(prgCode)
          tRow.appendChild(prgName)
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
