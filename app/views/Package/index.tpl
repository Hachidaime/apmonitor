<!-- prettier-ignore -->
{extends file='Templates/mainlayout.tpl'}

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
        <table class="table table-hover table-bordered table-sm text-nowrap">
          <thead>
            <tr>
              <th class="align-middle text-right" width="50px">#</th>
              <th class="align-middle text-center" width="120px">
                Tahun<br />Anggaran
              </th>
              <th class="align-middle text-center" width="*">Program</th>
              <th class="align-middle text-center" width="*">Kegiatan</th>
              <th width="120px">&nbsp;</th>
            </tr>
          </thead>
          <tbody>
            {section name=outer loop=$list}
            <tr>
              <td class="text-right" scope="row">
                {$smarty.const.ROWS_PER_PAGE * ($paging.currentPage - 1) +
                $smarty.section.outer.index + 1}
              </td>
              <td class="text-center">{$list[outer].pkg_fiscal_year}</td>
              <td>{$list[outer].prg_code}</td>
              <td>{$list[outer].act_code}</td>
              <td>
                <!-- prettier-ignore -->
                {include 'Templates/buttons/edit.tpl'}
                {include 'Templates/buttons/remove.tpl'}
              </td>
            </tr>
            {sectionelse}
            <tr>
              <td colspan="5" class="text-center">Data kosong ...</td>
            </tr>
            {/section}
          </tbody>
        </table>
      </div>
      <!-- /.card-body -->

      <div class="card-footer clearfix">
        {$pager}
      </div>
    </div>
    <!-- /.card -->
  </div>
</div>
<!-- prettier-ignore -->
{/block} 

{block 'script'} 
{literal}
<script>
  $(document).ready(function () {
    formTooltip('keyword', 'warning', 'top')

    /* Tombol Hapus */
    $('.btn-delete').click(function () {
      deleteData($(this).data('id'))
    })
  })
</script>
<!-- prettier-ignore -->
{/literal}
{/block}
