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
                data-title="Cari Kode Kegiatan"
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
        <table class="table table-hover table-sm text-nowrap">
          <thead>
            <tr>
              <th width="50px">#</th>
              <th width="100px">Fisik (%)</th>
              <th width="300px">Foto Fisik</th>
              <th width="100px">Keuangan (%)</th>
              <th width="*">Dokument Pendukung</th>
              <th width="50px">&nbsp;</th>
            </tr>
          </thead>
          <tbody>
            {section name=outer loop=$list}
            <tr>
              <td class="text-center" scope="row">
                {$smarty.const.ROWS_PER_PAGE * ($paging.currentPage - 1) +
                $smarty.section.outer.index + 1}
              </td>
              <td>{$list[outer].prog_physical}</td>
              <td>
                <span class="filename">{$list[outer].prog_physical_img}</span>
                <a
                  class="badge badge-light badge-pill"
                  title="Download"
                  href="{$smarty.const.BASE_URL}/upload/img/progress/{$list[outer].id}/{$list[outer].prog_physical_img}"
                  download
                  ><i class="fas fa-download"></i
                ></a>
              </td>
              <td>{$list[outer].prog_finance}</td>
              <td>{$list[outer].prog_document}</td>
              <td>
                <a
                  href="{$smarty.const.BASE_URL}/{$smarty.session.ACTIVE.name}/detail/{$list[outer].id}"
                  class="badge badge-pill badge-info my-tooltip"
                >
                  Detail
                </a>
              </td>
            </tr>
            {sectionelse}
            <tr>
              <td colspan="6" class="text-center">Data kosong ...</td>
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
  })
</script>
<!-- prettier-ignore -->
{/literal}
{/block}
