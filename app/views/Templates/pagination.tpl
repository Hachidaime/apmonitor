<div
  class="d-flex flex-column flex-sm-row justify-content-between align-items-center"
>
  <span><strong>Jumlah Data:</strong> {$paging.totalRows|default:0}</span>
  <nav aria-label="pagination">
    <ul class="pagination pagination-sm justify-content-end m-0">
      {if $paging.currentPage > $smarty.const.SURROUND_COUNT + 1}
      <li class="page-item">
        <a class="page-link" href="{$paging.uri}/page/1/{$paging.keyword}">
          First
        </a>
      </li>
      <li class="page-item">
        <a
          class="page-link"
          href="{$paging.uri}/page/{$paging.previousPage}/{$paging.keyword}"
        >
          Previous
        </a>
      </li>
      <li class="page-item">
        <a class="page-link" href="{$paging.uri}/page/1/{$paging.keyword}">
          1
        </a>
      </li>
      {if ($paging.pageMin - 1) ne 1}
      <li class="page-item">
        <span class="page-link">...</span>
      </li>
      <!-- prettier-ignore -->
      {/if}
      {/if}

      {if $paging.previousPage ne null}
      {for $prev=$paging.pageMin to $paging.previousPage}
      <li class="page-item">
        <a class="page-link" href="{$paging.uri}/page/{$prev}/{$paging.keyword}"
          >{$prev}</a
        >
      </li>
      <!-- prettier-ignore -->
      {/for}
      {/if}
      <li class="page-item active" aria-current="page">
        <span class="page-link">{$paging.currentPage}</span>
      </li>
      <!-- prettier-ignore -->
      {if $paging.nextPage ne null}
      {for $next=$paging.nextPage to $paging.pageMax}
      <li class="page-item">
        <a class="page-link" href="{$paging.uri}/page/{$next}/{$paging.keyword}"
          >{$next}</a
        >
      </li>
      <!-- prettier-ignore -->
      {/for}
      {/if}

      {if ($paging.lastPage - $paging.currentPage) > $smarty.const.SURROUND_COUNT}
      {if ($paging.pageMax + 1) ne $paging.lastPage}
      <li class="page-item">
        <span class="page-link">...</span>
      </li>
      {/if}
      <li class="page-item">
        <a
          class="page-link"
          href="{$paging.uri}/page/{$paging.lastPage}/{$paging.keyword}"
        >
          {$paging.lastPage}
        </a>
      </li>
      <li class="page-item">
        <a
          class="page-link"
          href="{$paging.uri}/page/{$paging.nextPage}/{$paging.keyword}"
        >
          Next
        </a>
      </li>
      <li class="page-item">
        <a
          class="page-link"
          href="{$paging.uri}/page/{$paging.lastPage}/{$paging.keyword}"
        >
          Last
        </a>
      </li>
      {/if}
    </ul>
  </nav>
</div>
